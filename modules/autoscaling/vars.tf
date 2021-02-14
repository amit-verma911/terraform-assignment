variable "key_name" {
  description = "SSH key to use for instances"
}

variable "name" {
  description = "Project Name"
}

variable "env" {
  description = "Environment Name"
}


variable "region" {
  description = "default region"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC where to deploy the resources"
}

variable "private_subnet_ids" {
  description = "list of private subnet IDs where to deploy the private resources"
  type        = "list"
}

variable "ec2_port" {
  # set to 22 by default so that health checks work when there is no application installed
  default = "22"
}

variable "ec2_asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "1"
}

variable "ec2_asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "1"
}

variable "ec2_asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "1"
}

variable "ec2_instance_type" {
  description = "EC2 instance type for instances in app tier"
  default     = "t2.micro"
}

# variable "frontend_instances_sg_id" {
#   description = "SG ID of the frontend instances"
# }

variable "ec2_ami_id" {
  description = "AMI ID to use for all instances"
}

variable "root_disk_size" {
  default = 16
}



# variable "r53_zone_id" {
#   description = "zone id of the private R53 hosted zone where to add A records for the DB instances"
# }


# variable "admin_access_sg_ids" {
#   type = "list"
# }


variable "user_port" {
  description = "user access port that will be open to admin access SGs (linux: 22, windows: 3389)"
}

variable "ec2_idle_timeout" {
  default = "300"
}

variable "dev_key_id" {
  description = "kms key for dev account"
}

variable "healthcheck_port" {
  default = 5000
}

