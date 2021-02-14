// Route tables for all private data - one route table per availability zone
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.name}-${var.env}-private-rtbl-${count.index}"
  }

  count = "${var.az_count}"
}


// Private subnets
resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(var.cidr,3,count.index + 4)}"
  availability_zone    = "${data.aws_availability_zones.available.names[count.index]}"
  count = "${var.az_count}"

  tags {
    Name = "${var.name}-${var.env}-private-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${var.az_count}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}


// Public subnets
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.name}-${var.env}-public-rtbl"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(var.cidr,3,count.index)}"
  availability_zone    = "${data.aws_availability_zones.available.names[count.index]}"
  count = "${var.az_count}"

  tags {
    Name = "${var.name}-${var.env}-public-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${var.az_count}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

// Route from Public to our internet gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.vpc.id}"
}
