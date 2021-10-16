locals {
  vpc_cidr = "10.0.0.0/16"
}

locals {
    security_groups = {
        public = { //key
            name = "public_sg" //values
            description = "Public Security Group"
            ingress = {
                ssh = {
                    from = 22
                    to = 22
                    protocol = "tcp"
                    cidr_blocks = [var.access_ip]
                }
                
                http = {
                    from = 80
                    to = 80
                    protocol = "tcp"
                    cidr_blocks = [var.access_ip]
                }
                nginx = {
                    from = 8000
                    to = 8000
                    protocol = "tcp"
                    cidr_blocks = [var.access_ip]
                }
            }
        }
        
        rds = { //key
            name = "rds_sg" //values
            description = "rds Security Group"
            ingress = {
                mysql = {
                    from = 3306
                    to = 3306
                    protocol = "tcp"
                    cidr_blocks = [local.vpc_cidr]
                }
                
            }
        }
    }
}