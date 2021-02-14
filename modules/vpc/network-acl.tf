// Network ACLs

// Define out public Network ACLs first
resource "aws_network_acl" "public_acl" {
  vpc_id     = "${aws_vpc.vpc.id}"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  tags {
    Name = "${var.name}-${var.env}-public-acl"
  }
}

// Apply all whitelist rules inbound on the public subnet
resource "aws_network_acl_rule" "inbound_whitelist_rules" {
  network_acl_id = "${aws_network_acl.public_acl.id}"
  count          = "${length(var.whitelist)}"
  rule_number    = "${count.index + 100}"
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "${element(var.whitelist, count.index)}"
}

// Apply an outbound rule to allow all traffic out
resource "aws_network_acl_rule" "outbound_rule" {
  network_acl_id = "${aws_network_acl.public_acl.id}"
  rule_number    = "100"
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

// Allow access from whole VPC
resource "aws_network_acl_rule" "inbound_from_vpc" {
  network_acl_id = "${aws_network_acl.public_acl.id}"
  rule_number    = "300"
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "${var.cidr}"
}

// Optionally allow https tcp port. Set variable "enable_https_from_all_acl" to a value ("1", for example) to add this rule
resource "aws_network_acl_rule" "public_inbound_https_tcp" {
  count          = "${var.enable_https_from_all_acl}"
  network_acl_id = "${aws_network_acl.public_acl.id}"
  rule_number    = "206"
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

//
// Private Subnet Network ACLs
//

// First the private Network ACL itself
resource "aws_network_acl" "private_acl" {
  vpc_id     = "${aws_vpc.vpc.id}"
  subnet_ids = ["${aws_subnet.private.*.id}"]
  tags {
    Name = "${var.name}-${var.env}-private-acl"
  }
}

// Allow all inbound traffic from the whole VPC
resource "aws_network_acl_rule" "internal_inbound_from_vpc" {
  network_acl_id = "${aws_network_acl.private_acl.id}"
  rule_number    = "100"
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "${var.cidr}"
}


// Allow all outbound traffic to the whole VPC
resource "aws_network_acl_rule" "internal_outbound_to_vpc" {
  network_acl_id = "${aws_network_acl.private_acl.id}"
  rule_number    = "100"
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "${var.cidr}"
}

// Allow specific outbound ports and traffic
resource "aws_network_acl_rule" "private_outbound_ssh" {
  network_acl_id = "${aws_network_acl.private_acl.id}"
  rule_number    = "200"
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

// HTTP
resource "aws_network_acl_rule" "private_outbound_http" {
  network_acl_id = "${aws_network_acl.private_acl.id}"
  rule_number    = "201"
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

// HTTPS
resource "aws_network_acl_rule" "private_outbound_https" {
  network_acl_id = "${aws_network_acl.private_acl.id}"
  rule_number    = "202"
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}
