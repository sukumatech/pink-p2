terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

provider "google" {
  project = var.project
}

data "google_client_config" "default" {}

provider "docker" {
  registry_auth {
    address  = "gcr.io"
    username = "oauth2accesstoken"
    password = data.google_client_config.default.access_token
  }
}

data "google_container_registry_image" "myapp_tagged" {
  name = "calc-image"
  tag  = "latest"
}

data "docker_registry_image" "myapp" {
  name = "${data.google_container_registry_image.myapp_tagged.image_url}"
}

data "google_container_registry_image" "myapp" {
  name   = "calc-image"
  digest = "${data.docker_registry_image.myapp.sha256_digest}"
}

output "gcr_image_info" {
  value = data.google_container_registry_image.myapp
}



# ---------------------------------------------------------------------------------------------------------------------
# cloudrun
# ---------------------------------------------------------------------------------------------------------------------
module "cloudrun" {
  source = "./../../_modules/terraform-gcp-cloudrun"

  for_each = toset(var.location)
  name = "${var.environment}-${lower(each.key)}-${random_string.name.result}-${var.appname}"
  location = jsondecode(file("${path.module}/c-code.tftpl"))[each.key]

  image    = data.google_container_registry_image.myapp.image_url
  max_instances = var.max_instances
  min_instances = var.min_instances

}

# ---------------------------------------------------------------------------------------------------------------------
# IAM POLICICY
#IT ALLOWS EVERYONE TO MAKE CONNECTION
# ---------------------------------------------------------------------------------------------------------------------
module "iam-policy" {
  source = "./../../_modules/terraform-gcp-iam"

  //google_iam_policy
  role = "roles/run.invoker"
  members = ["allUsers"]
  project= var.project

  //loop through the regions with individual policies
  for_each = module.cloudrun
  service= each.value.name
  location = jsondecode(file("${path.module}/c-code.tftpl"))[each.key]
  depends_on = [
    module.cloudrun
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# END POINTS
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_region_network_endpoint_group" "cloudrun_endpoint" {

  project = var.project

  for_each = module.cloudrun
  name = each.value.name
  region = jsondecode(file("${path.module}/c-code.tftpl"))[each.key]
  network_endpoint_type = "SERVERLESS"
  

  cloud_run {
    service = each.value.name
  }

  depends_on = [
    module.iam-policy
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# HTTP LOADBALANCER
#https://registry.terraform.io/modules/GoogleCloudPlatform/lb-http/google/latest/submodules/serverless_negs
# ---------------------------------------------------------------------------------------------------------------------
module "lb-http" {
  source            = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  project           = var.project
  version           = "6.2.0"
  name              = "${var.environment}-${random_string.name.result}-${var.appname}"

  ssl                             = false
  managed_ssl_certificate_domains = [null]
  https_redirect                  = false
  http_forward                    = true
  create_url_map                  = true
  backends = {
    default = {
      description                     = null
      enable_cdn                      = false
      custom_request_headers          = null
      custom_response_headers         = null
      security_policy                 = null


      log_config = {
        enable = false
        sample_rate = null
      }

      groups = [
      for neg in google_compute_region_network_endpoint_group.cloudrun_endpoint:
        {
          group = neg.id
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }

  depends_on = [
    google_compute_region_network_endpoint_group.cloudrun_endpoint
  ]
}


# ---------------------------------------------------------------------------------------------------------------------
# OUTPUT TO CONSOLE
# ---------------------------------------------------------------------------------------------------------------------

output "external-ip" {
  value = module.lb-http.external_ip
}
output "urlmap" {
  value = module.lb-http.url_map
}
output "url" {
  value = [
    for i in module.cloudrun : i.url
  ]
}
