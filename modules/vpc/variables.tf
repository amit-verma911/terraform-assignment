variable "aws_region" {
  default = "us-east-1"
}
variable "account" {}
variable "name" {}
variable "project" {}
variable "env" {}
variable "cidr" {}
variable "az_count" {}
variable "whitelist" {
  default = []
}

#variable "kms_key_arn" {}

variable "vgw_tags" {
  type        = "map"
  description = "Transit VPC Tags for the VGW"

  default = {
    "transitvpc:env"   = "none"
    "transitvpc:spoke" = "false"
  }
}

variable "enable_https_from_all_acl" {
  description = "Optionally allow https tcp port. Set variable 'enable_https_from_all_acl' to true to add this rule"
  default     = false
}
