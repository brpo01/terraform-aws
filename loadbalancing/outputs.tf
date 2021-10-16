output "target_group_arn" {
    value = aws_lb_target_group.main_lb_tg.arn
}

output "lb_endpoint" {
    value = aws_lb.main_lb.dns_name
}