data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.project}-${var.env}-vpc"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.project}-${var.env}-igw"
  }
}