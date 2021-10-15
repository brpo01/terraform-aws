#-- 

resource "aws_lb" "main_lb" {
    name = "main-lb"
    subnets = var.public_subnet
    security_groups = [var.public_sg]
    idle_timeout = 400
}

resource "aws_lb_target_group" "main_lb_tg" {
    name = "main-lb-tg-${substr(uuid(), 0, 3)}"
    port = var.tg_port
    protocol = var.tg_protocol
    vpc_id = var.vpc_id
    
    health_check {
        healthy_threshold = var.tg_healthy_threshold
        unhealthy_threshold = var.tg_unhealthy_threshold
        timeout = var.tg_timeout
        interval = var.tg_interval
    }
}