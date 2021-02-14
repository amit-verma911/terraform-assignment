// S3 VPC endpoint
resource "aws_vpc_endpoint" "private-s3" {
  vpc_id = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = ["${concat(aws_route_table.private.*.id, aws_route_table.public.*.id)}"]
}