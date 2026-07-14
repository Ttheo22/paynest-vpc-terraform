output "vpc_id" {
    value = aws_vpc.main.id
  }

  output "public_subnet_ids" {
    value = aws_subnet.public[*].id
  }

  output "private_subnet_ids" {
    value = aws_subnet.private[*].id
  }

  output "private_instance_id" {
    value = aws_instance.paynest_private_instance.id
  }