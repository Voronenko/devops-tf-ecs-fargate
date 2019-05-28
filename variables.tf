variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "az_count" {
  description = "No of AZs to cover"
  default     = "2"
}

variable "app_image" {
  description = "Image to run"
  default     = "voronenko/docker-sample-image:47372c4"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "app_port_public" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}


variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "ecs_cluster" {
  description = "ECS cluster name"
  default = "crochunter-fargate"
}

variable "ec2_key" {
  description = "key used on ec2 instances for troubleshouting"
  default = "voronenko_info"
}

locals {

  app_name = "crochunter-fargate"

  env = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
  region = "${var.environment_to_region_map[local.env]}"
  readable_env_name = "${local.app_name}-${local.env}"

  ecs_cluster_name = "${var.ecs_cluster}-${terraform.workspace}"
}
