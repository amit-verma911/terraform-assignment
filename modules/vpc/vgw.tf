resource "aws_vpn_gateway" "vgw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.vgw_tags, map("Name","${var.name}-${var.env}-vgw"))}"
}
