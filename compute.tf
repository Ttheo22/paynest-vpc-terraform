data "aws_ami" "private_instance_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}


resource "aws_instance" "paynest_private_instance" {
  ami                         = data.aws_ami.private_instance_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private[0].id
  vpc_security_group_ids      = [aws_security_group.paynest_private_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  associate_public_ip_address = false

  tags = merge(local.common_tags, { Name = "${var.project}-private-instance" })
}


