resource "random_string" "name" {
  length  = 3
  upper   = false
  number  = false
  lower   = true
  special = false
}

variable "environment" {
  type = string
}

locals {
  region = jsondecode(file("${path.module}./../profiles/cloudrun/c-code.tftpl"))[var.gcp_region]
  name = "${var.environment}-${lower(var.gcp_region)}-${random_string.name.result}-${var.appname}"
}

variable "appname" {
  type        = string
  description = "Name of the service."
  default = "app"
}

variable "gcp_region" {
  type        = string
  description = "GCP region"
}

variable "gcp_project" {
  type        = string
  description = "GCP project name"
}

variable "bucket_name" {
  type        = string
  description = "The name of the Google Storage Bucket to create"
}

variable "storage_class" {
  type        = string
  description = "The storage class of the Storage Bucket to create"
}