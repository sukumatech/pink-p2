provider "google" {
  region =  "${local.region}"
}

module "remote-storage" {
  source = "./../../_modules/terraform-gcp-remote-backend"

  gcp_region    = "${local.region}"
  gcp_project   = var.gcp_project
  bucket_name   = "${local.name}-bucket"
  storage_class = var.storage_class
}