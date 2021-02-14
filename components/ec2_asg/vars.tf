variable "vpc_id" {
  description = "VPC where to deploy resources"
  default     = "vpc-0010a058e93e8114e"
}

variable "private_subnets_ids" {
  type        = "list"
  description = "private subnet IDs where to deploy resources"
  default     = ["subnet-0a3141ff6299b202d", "subnet-048f6db2695f67d14"]
}

variable "public_subnets_ids" {
  type        = "list"
  description = "public subnet IDs where to deploy resources"
  default     = ["subnet-0670de94ab60cc03c", "subnet-0eb6b8c4756bac5e7"]
}

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

variable "ec2_key_name" {
  description = "Key Pair for ec2"
  default     = "dev_test"
}

variable "ec2_instance_type" {
  description = "ec2 instance type"
  default     = "t2.micro"
}

variable "ec2_asg_min" {
  description = "ec2 ASG minimum"
  default     = "1"
}

variable "ec2_asg_max" {
  description = "ec2 ASG maximum"
  default     = "1"
}

variable "ec2_asg_desired" {
  description = "ec2 ASG desired"

  default = "1"
}

variable "storage" {
  description = "allocated storage in GB"

  default = "20"
}

variable "storage_type" {
  description = "one of: standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD)"

  default = "gp2"
}

variable "ec2_admin_access_port" {
  description = "admin access port that will ec2 open to admin access SGs (linux: 22, windows: 3389)"

  default = "22"
}

variable "ec2_healthcheck_port" {
  default = "5000"
}

variable "ec2_port" {
  default = "22"
}

variable "root_disk_size" {
  default = "20"
}

variable "ec2_ami_id" {
  default = "ami-047a51fa27710816e"
}

variable "ec2_idle_timeout" {
  default = "300"
}

variable "dev_key_id" {
  default = "arn:aws:kms:us-east-1:077302500821:key/dfd612b1-182d-4514-b86b-9a936adfc5fa"
}

variable "user_port" {
  description = "user access port that will be open to admin access SGs (linux: 22, windows: 3389)"

  default = "22"
}
