output "ec2_instances_sg_id" {
  value = "${aws_security_group.ec2_instances_sg.id}"
}

output "ec2_elb_name" {
  value = "${aws_elb.ec2_elb.name}"
}

output "aws_autoscaling_group_name" {
  value = "${aws_autoscaling_group.ec2_asg.name}"
}
