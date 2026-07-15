output "vpc_id" {
    value = aws_vpc.main.id
  }

  output "public_subnet_ids" {
    value = aws_subnet.public[*].id
  }

  output "private_subnet_ids" {
    value = aws_subnet.private[*].id
  }


output "alb_dns_name" {
  value = aws_lb.paynest_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.paynest_alb_target_group.arn
}