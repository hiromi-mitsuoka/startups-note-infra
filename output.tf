output "vpc_arn" {
  value = aws_vpc.main.arn
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_1a_id" {
  value = aws_subnet.public_1a.id
}

output "public_subnet_1c_id" {
  value = aws_subnet.public_1c.id
}

output "private_subnet_1a_id" {
  value = aws_subnet.private_1a.id
}

output "private_subnet_1c_id" {
  value = aws_subnet.private_1c.id
}

output "alb_dns_name" {
  value = aws_lb.startups_note_alb.dns_name
}

output "domain_name" {
  value = aws_route53_record.startups_note.name
}

output "change_db_password" {
  value = "aws rds modify-db-instance --db-instance-identifier 'startups' --master-user-password '〇〇'"
}