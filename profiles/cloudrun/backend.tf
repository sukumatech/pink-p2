terraform {
  backend "gcs" {
    bucket = "dev-io-taw-app-bucket"
    prefix = "terraform/production.tfstate"
  }
}