// NAT elastic ip addresses
resource "aws_eip" "nat" {
  vpc   = true
  count = "${var.az_count}"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  count         = "${var.az_count}"
}

// Setup NAT route for the Private subnet
resource "aws_route" "nat_gateway" {
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  count                  = "${var.az_count}"

  depends_on = [
    "aws_route_table.private"
  ]
}
