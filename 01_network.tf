# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = true  # Remove this for case with NAT
  tags = {
    Name = "${local.readable_env_name}-private"
    env = local.env
  }

}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.readable_env_name}-public"
    env = local.env
  }

}

# IGW for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.readable_env_name}-igw"
    env = local.env
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}


# Create a NAT gateway with an EIP for each private subnet to get internet connectivity
# Uncomment for proper setup
//resource "aws_eip" "gw" {
//  count      = "${var.az_count}"
//  vpc        = true
//  depends_on = ["aws_internet_gateway.gw"]
//}

//resource "aws_nat_gateway" "gw" {
//  count         = "${var.az_count}"
//  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
//  allocation_id = "${element(aws_eip.gw.*.id, count.index)}"
//}

//# Create a new route table for the private subnets
//# And make it route non-local traffic through the NAT gateway to the internet
//resource "aws_route_table" "private" {
//  count  = "${var.az_count}"
//  vpc_id = "${aws_vpc.main.id}"
//
//  route {
//    cidr_block = "0.0.0.0/0"
//    nat_gateway_id = "${element(aws_nat_gateway.gw.*.id, count.index)}"
//  }
//}
//
//# Explicitely associate the newly created route tables to the private subnets (so they don't default to the main route table)
//resource "aws_route_table_association" "private" {
//  count          = "${var.az_count}"
//  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
//  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
//}

# /Uncomment for proper setup

# Comment for proper setup
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${local.readable_env_name}-rt-private"
    env = local.env
  }

}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# /Comment for proper setup