//required
resource "random_string" "name" {
  length  = 3
  upper   = false
  number  = false
  lower   = true
  special = false
}

variable "environment" {
  type = string
  //default = [dev, prd, stg]
}

locals {
  #name = "${var.environment}-${random_string.name.result}-service"
  region = jsondecode(file("${path.module}/c-code.tftpl"))[var.location]
  #code = "${var.location}"
  name = "${var.environment}-${lower(var.location)}-${random_string.name.result}-${var.appname}"
}

variable "appname" {
  type        = string
  description = "Name of the service."
  default = "app"
}

variable "location" {
  type        = string
  description = "Location of the service."
  default = "us-central1"
}
#--------------------------------------------------- NAMING CONVENTION IS ABOVE SHOULD BE A MODULE-----------------------------------------------------
variable "image" {
  type        = string
  description = "Docker image name."
  default = "gcr.io/terraform-gcptap/calc:v3"
}



variable "project" {
  type        = string
  default     = "terraform-gcptap"
  description = "Google Cloud project in which to create resources."
}

// Optional Inputs
variable "port" {
  type        = number
  default     = 80
  description = "Port on which the container is listening for incoming HTTP requests."
}

variable "max_instances" {
  type        = number
  default     = 10
  description = "Maximum number of container instances allowed to start."
}

variable "min_instances" {
  type        = number
  default     = 1
  description = "Minimum number of container instances to keep running."
}

variable "revision" {
  type        = string
  default     = true
  description = "Revision name to use. When `null`, revision names are automatically generated."
}

//variables for AIM policy 
variable "service" {
  description = "(Required) The service name for IAM policy to be attached to."
  type        = string
  default = ""
}

//naming 