provider "google" {
  project = var.project
  region  = var.location
}

terraform {
  backend "gcs" {
    bucket = "dev-io-taw-app-bucket"
    prefix = "terraform/cloudrun.tfstate"
  }
}