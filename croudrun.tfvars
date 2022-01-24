appname          = "calc"
location      = "HA"
image         = "gcr.io/terraform-gcptap/calc:v3"
port          = 80
max_instances = 5
min_instances = 1
revision      = true
environment = "dev"