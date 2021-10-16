output "lb_endpoint" {
    value = module.loadbalancing.lb_endpoint
}

output "instances" {
    value = {for i in module.compute.instance : i.tags.Name => "${i.public_ip}:${module.compute.instance_port}"}
    sensitive = true
}

