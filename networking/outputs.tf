output "vpc_id" {
  value = aws_vpc.main_vpc.id
} 

output "db_subnet_group_name" {
    value = aws_db_subnet_group.main_subnet_group.*.name
}

output "vpc_security_groups_ids" {
    value = [aws_security_group.main_sg["rds"].id]
}

output "public_subnets" {
    value = aws_subnet.public_subnet.*.id
}

output "public_sg" {
    value = aws_security_group.main_sg["public"].id
}