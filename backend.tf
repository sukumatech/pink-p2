terraform {
  backend "gcs" {
    bucket = "dev-io-kxd-app-bucket"
    prefix = "terraform-hel/vpc.tfstate"
  }
}