output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "private_subnets_id" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "private_subnet_cidrs" {
  value = ["${aws_subnet.private.*.cidr_block}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "public_subnet_cidrs" {
  value = ["${aws_subnet.public.*.cidr_block}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_route_table_id" {
  value = "${element(concat(aws_route_table.public.*.id, list("")), 0)}"
}

output "private_route_table_id" {
  value = "${element(concat(aws_route_table.private.*.id, list("")), 0)}"
}

output "public_route_table_ids" {
  value = ["${aws_route_table.public.*.id}"]
}

output "private_route_table_ids" {
  value = ["${aws_route_table.private.*.id}"]
}


output "default_security_group_id" {
  value = "${aws_vpc.vpc.default_security_group_id}"
}

/*
output "r53_zone_id" {
  value = "${aws_route53_zone.default.zone_id}"
}
*/
