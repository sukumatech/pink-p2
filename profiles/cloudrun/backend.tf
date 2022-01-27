terraform {
  backend "gcs" {
    bucket = "dev-io-zew-app-bucket"
    prefix = "terraform/cloudrun.tfstate"
  }
}