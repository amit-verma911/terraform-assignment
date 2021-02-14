variable "aws_region" {}
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

variable "trusted_networks" {
  default = ["10.210.0.0/16", "10.211.0.0/16", "10.222.0.0/16"]
}

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
