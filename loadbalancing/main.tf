#-- 

resource "aws_lb" "main_lb" {
    name = "main-lb"
    subnets = var.public_subnet
    security_groups = [var.public_sg]
    idle_timeout = 400
}