variable "workspace_to_environment_map" {
  type = "map"
  default = {
    default = "default"
    dev     = "dev"
    qa      = "qa"
    staging = "staging"
    prod    = "prod"
  }
}

variable "environment_to_region_map" {
  type = "map"
  default = {
    default = "eu-west-1"
    dev     = "eu-west-1"
    qa      = "eu-west-1"
    staging = "eu-west-1"
    prod    = "eu-west-1"
  }
}
