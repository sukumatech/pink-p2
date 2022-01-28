variable "name" {
  type = string
  description = "Name of the service."
}

variable "image" {
  type = string
  description = "Docker image name."
}

variable "location" {
  type = string
  description = "Location of the service."
}

// --
variable "project" {
  type = string
  default = null
  description = "Google Cloud project in which to create resources."
}

variable "port" {
  type = number
  default = 80
  description = "Port on which the container is listening for incoming HTTP requests."
}

variable "concurrency" {
  type = number
  default = null
  description = "Maximum allowed concurrent requests per container for this revision."
}

variable "cpus" {
  type = number
  default = 1
  description = "Number of CPUs to allocate per container."
}

variable "cpu_throttling" {
  type = bool
  default = true
  description = "Configure CPU throttling outside of request processing."
}

//figure labels out (might be useful when running deployments)

variable "labels" {
  type = map(string)
  default = {}
  description = "Labels to apply to the service."
}

variable "max_instances" {
  type = number
  default = 1000
  description = "Maximum number of container instances allowed to start."
}

variable "memory" {
  type = number
  default = 256
  description = "Memory (in Mi) to allocate to containers."
}

variable "min_instances" {
  type = number
  default = 0
  description = "Minimum number of container instances to keep running."
}

variable "timeout" {
  type = number
  default = 60
  description = "Maximum duration (in seconds) allowed for responding to requests."
}

variable "revision" {
  type = string
  default = null
  description = "Revision name to use. When `null`, revision names are automatically generated."
}