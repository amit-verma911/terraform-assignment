# aws launch configuration for asg
resource "aws_launch_configuration" "ec2_asg_lc" {
  key_name                    = "${var.key_name}"
  associate_public_ip_address = false
  name_prefix                 = "${var.name}-${var.env}-ec2-asg-lc-"
  image_id                    = "${var.ec2_ami_id}" #select any ami from ec2 console and update in variables file  instance_type = "${var.backend_instance_type}"
  security_groups             = ["${aws_security_group.ec2_instances_sg.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.ec2_instance_profile.id}"
  instance_type               = "${var.ec2_instance_type}"

  #user_data = "${data.template_file.backend_user_data.rendered}"
  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = "${var.root_disk_size}"
  }
}

# ec2 ASG
resource "aws_autoscaling_group" "ec2_asg" {
  name                      = "${var.name}-${var.env}-ec2-asg"
  max_size                  = "${var.ec2_asg_max}"
  min_size                  = "${var.ec2_asg_min}"
  desired_capacity          = "${var.ec2_asg_desired}"
  launch_configuration      = "${aws_launch_configuration.ec2_asg_lc.name}"
  load_balancers            = ["${aws_elb.ec2_elb.name}"]
  vpc_zone_identifier       = ["${var.private_subnet_ids}"]
  health_check_grace_period = 300

  #health_check_type = "ELB"
  #service_linked_role_arn = "${aws_iam_service_linked_role.autoscaling-ec2.arn}"

  #   service_linked_role_arn = "arn:aws:iam::077302500821:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

  tag {
    key                 = "Name"
    value               = "${var.name}-${var.env}-ec2-asg"
    propagate_at_launch = true
  }

  #depends_on = ["aws_iam_service_linked_role.autoscaling-ec2"]
}


#scale up alarm

resource "aws_autoscaling_policy" "ec2_test_cpu_policy" {
  name                   = "${var.name}-${var.env}-test-cpu-policy"
  autoscaling_group_name = "${aws_autoscaling_group.ec2_asg.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "ec2_test_cpu_alarm" {
  alarm_name          = "ec2-test-cpu-alarm"
  alarm_description   = "ec2-test-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = "aws_autoscaling_group.ec2_asg.name"
  }

  actions_enabled = "true"
  alarm_actions   = ["${aws_autoscaling_policy.ec2_test_cpu_policy.arn}"]

}

#scale down alarm

resource "aws_autoscaling_policy" "ec2_test_cpu_scaledown_policy" {
  name                   = "${var.name}-${var.env}-test-cpu-scaledown-policy"
  autoscaling_group_name = "${aws_autoscaling_group.ec2_asg.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "ec2_test_cpu_alarm_scaledown" {
  alarm_name          = "ec2-test-cpu-scaledown-alarm"
  alarm_description   = "ec2-test-cpu-scaledown-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = "aws_autoscaling_group.ec2_asg.name"
  }

  actions_enabled = "true"
  alarm_actions   = ["${aws_autoscaling_policy.ec2_test_cpu_scaledown_policy.arn}"]

}



# ec2 ELB for health checks
resource "aws_elb" "ec2_elb" {
  name         = "${var.name}-${var.env}-ec2-elb"
  internal     = true
  idle_timeout = "${var.ec2_idle_timeout}"

  subnets         = ["${var.private_subnet_ids}"]
  security_groups = ["${aws_security_group.ec2_elb_sg.id}"]

  # health_check {
  #   healthy_threshold = 2
  #   unhealthy_threshold = 5
  #   timeout = 40
  #   target = "HTTP:${var.healthcheck_port}/api/health"
  #   interval = 60
  # }

  listener {
    instance_port     = "${var.ec2_port}"
    instance_protocol = "http"
    lb_port           = "${var.ec2_port}"
    lb_protocol       = "http"
  }
  tags {
    Name = "${var.name}-${var.env}-ec2-elb"
  }
}

# ec2 ELB SG
resource "aws_security_group" "ec2_elb_sg" {
  name = "${var.name}-${var.env}-ec2-elb-sg"

  vpc_id      = "${var.vpc_id}"
  description = "ec2 elb security group"

  # access from your ip
  ingress {
    from_port = "${var.user_port}"
    to_port   = "${var.user_port}"
    protocol  = "tcp"

    #    security_groups = ["${var.}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}-${var.env}-ec2-elb-sg"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.name}-${var.env}-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "SSM_policy_attachment" {
  role       = "${aws_iam_role.ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}


# resource "aws_iam_service_linked_role" "autoscaling-ec2" {
#   aws_service_name = "autoscaling.amazonaws.com"
#   custom_suffix    = "test_ec2${var.env}"
# }

# resource "aws_kms_grant" "ec2_grant" {
#   name              = "ec2-grant-${var.env}"
#   key_id            = "${var.dev_key_id}"
#   grantee_principal = "${aws_iam_service_linked_role.autoscaling-ec2.arn}"
#   operations        = ["Encrypt", "Decrypt", "GenerateDataKey", "ReEncryptFrom", "ReEncryptTo", "GenerateDataKeyWithoutPlaintext", "DescribeKey", "CreateGrant"]
# }



resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name  = "${var.name}-${var.env}-ec2-instance_profile"
  roles = ["${aws_iam_role.ec2_role.name}"]
}

# SG for ec2 instances
resource "aws_security_group" "ec2_instances_sg" {
  name        = "${var.name}-${var.env}-ec2-instances_sg"
  vpc_id      = "${var.vpc_id}"
  description = "ec2 instances security group"

  # HTTP access from the VPC
  ingress {
    from_port       = "${var.healthcheck_port}"
    to_port         = "${var.healthcheck_port}"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ec2_elb_sg.id}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.name}-${var.env}-ec2-instances-sg"
  }
}
