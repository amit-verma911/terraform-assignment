# Variables

variable "aws_region" {
  default = "us-east-1"
}

variable "name" {
  default = "test"
}

variable "project" {
  default = "test"
}

variable "env" {
  default = "dev"
}

variable "cidr" {
  default = "10.192.192.0/23"
}

variable "az_count" {
  default = "2"
}

variable "whitelist" {
  default = []
}

#variable "kms_key_arn" {}

# variable "trusted_networks" {
#   default = ["10.210.0.0/16", "10.211.0.0/16", "10.222.0.0/16"]
# }

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
