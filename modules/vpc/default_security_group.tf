resource "aws_security_group" "vpc_private_sg" {
  name        = "${var.project}-${var.env}-vpc-private-sg"
  description = "VPC Private Security Group - ${var.env}"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.project}-${var.env}-vpc-private-sg"
  }
}
