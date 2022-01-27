terraform {
  backend "gcs" {
    bucket = "dev-io-nsv-app-bucket"
    prefix = "terraform/storage.tfstate"
  }
}