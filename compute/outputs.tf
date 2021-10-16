output "instance" {
    value = aws_instance.main_instance[*]
    sensitive = true
}

output "instance_port" {
    value = aws_lb_target_group_attachment.main_tg_attachment[0].port
}