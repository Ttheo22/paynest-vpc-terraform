data "aws_ami" "private_instance_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_launch_template" "paynest_private_instance_lt" {
  name_prefix   = "${var.project}-private-instance-lt-"
  image_id      = data.aws_ami.private_instance_ami.id
  instance_type = var.instance_type


  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.paynest_private_sg.id]
  }

  tags = merge(local.common_tags, { Name = "${var.project}-private-instance" })
}

resource "aws_autoscaling_group" "paynest_private_asg" {
  name                      = "${var.project}-private-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.private[*].id
  target_group_arns         = [aws_lb_target_group.paynest_alb_target_group.arn]
  launch_template {
    id      = aws_launch_template.paynest_private_instance_lt.id
    version = "$Latest"
  }

tag {
  key                 = "Project"
  value               = var.project
  propagate_at_launch = true
}

tag {
  key                 = "Environment"
  value               = var.environment
  propagate_at_launch = true
}
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "${var.project}-scale-up-policy"
  autoscaling_group_name = var.aws_autoscaling_group.paynest_private_asg.name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  
}


