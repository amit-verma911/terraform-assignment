#ec2 instances with asg

module "ec2_asg" {
  source             = "../../modules/autoscaling"
  vpc_id             = "${var.vpc_id}"
  private_subnet_ids = "${var.private_subnets_ids}"
  key_name           = "${var.ec2_key_name}"
  name               = "${var.name}"
  env                = "${var.env}"
  ec2_ami_id         = "${var.ec2_ami_id}"
  ec2_instance_type  = "${var.ec2_instance_type}"
  ec2_asg_min        = "${var.ec2_asg_min}"
  ec2_asg_max        = "${var.ec2_asg_max}"
  ec2_asg_desired    = "${var.ec2_asg_desired}"
  user_port          = "${var.user_port}"
  dev_key_id         = "${var.dev_key_id}"
  ec2_port           = "${var.ec2_port}"

  #healthcheck_port                             = "${var.be_healthcheck_port}"
  root_disk_size = "${var.root_disk_size}"
}
