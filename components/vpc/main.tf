data "aws_caller_identity" "current" {}

module "vpc" {
  source     = "../../modules/vpc"
  cidr       = "${var.cidr}"
  az_count   = "${var.az_count}"
  account    = "${data.aws_caller_identity.current.account_id}"
  name       = "${var.name}"
  project    = "${var.project}"
  aws_region = "${var.aws_region}"
  env        = "${var.env}"

  #kms_key_arn               = "${var.kms_key_arn}"
  vgw_tags                  = "${var.vgw_tags}"
  enable_https_from_all_acl = "${var.enable_https_from_all_acl}"
}
