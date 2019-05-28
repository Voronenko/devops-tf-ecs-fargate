resource "aws_vpc" "main" {
  cidr_block = "172.17.0.0/16"
  tags {
    Name = "${local.readable_env_name}"
    env = "${local.env}"
  }
}
