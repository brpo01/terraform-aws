#-- root/main.tf

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  security_groups = local.security_groups
  access_ip = var.access_ip
  public_sn_count  = 2
  private_sn_count = 3
  max_subnets      = 10
  public_cidr      = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidr     = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnet_group = true
}

module "database" {
  source = "./database"
  db_storage = 10
  db_engine_version = "5.7.22"
  db_instance_class = "db.t2.micro"
  dbname = var.dbname
  dbusername = var.dbusername
  dbpassword = var.dbpassword
  db_subnet_group_name = module.networking.db_subnet_group_name[0]
  vpc_security_groups_ids = module.networking.vpc_security_groups_ids
  db_identifier = "main-db"
}

module "loadbalancing" {
  source = "./loadbalancing"
  public_subnet = module.networking.public_subnets
  public_sg = module.networking.public_sg
  tg_port = 80
  tg_protocol = "HTTP" 
  vpc_id = module.networking.vpc_id
  tg_healthy_threshold = 2
  tg_unhealthy_threshold = 2 
  tg_interval = 30
  tg_timeout = 3
  listener_port = 80
  listener_protocol = "HTTP"
}

module "compute" {
  source = "./compute"
  instance_count = 1
  instance_type = "t3.micro"
  public_sg = module.networking.public_sg
  public_subnet = module.networking.public_subnets
  vol_size = 10
}
