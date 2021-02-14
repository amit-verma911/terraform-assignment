# Each vpc needs a set of domains created and associated with it.
# * One grandfathered in from the old pattern
# * One purely local for solipsistic environments
# * One for peer resolution


# Grandfathering in the foo-test domain for now


resource "aws_route53_zone" "default" {
  #  count = "${var.featureswitch_hub? 1 : 0}"
  name    = "foo-test.com"
  comment = "firm zone for ${var.env}"
  vpc {
    vpc_id = "${aws_vpc.vpc.id}"
    #vpc_id = "${var.vpc_id}"
  }
  tags {
    Name        = "${var.project}-${var.env}-r53-default"
    Environment = "${var.env}"
  }
}
