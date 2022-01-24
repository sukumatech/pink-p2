provider "google" {
  project = var.project
  region = "${local.region}"
}

provider "google-beta" {
  project = var.project
}

resource "google_compute_region_network_endpoint_group" "cloudrun" {
  project           = var.project
  name                  = "${local.name}-endpoint"
  network_endpoint_type = "SERVERLESS"
  region                = "${local.region}"
  cloud_run {
    service = module.cloudrun.name
  }
}

module "cloudrun" {
  source = "../../_modules/terraform-gcp-cloudrun"

  #service defaults
  name     = "${local.name}-service"
  location = "${local.region}"

  #template/specs
  image    = var.image
  #container_port = var.port

  #control ammount of instances
  max_instances = var.max_instances
  min_instances = var.min_instances

}

module "iam-policy" {
    source = "./../../_modules/terraform-gcp-iam"
    
    //google_iam_policy
    role = "roles/run.invoker"
    members = ["allUsers"]

    //google_cloud_run_service_iam_policy
    project= var.project
    service= module.cloudrun.name
    location= "${local.region}"
}

output "url" {
  value = module.cloudrun.url
}
