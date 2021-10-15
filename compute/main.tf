#-- compute/main.tf

data "aws_ami" "main_ami" {
    most_recent = true
    owners = ["099720109477"]
    
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
}


resource "random_id" "main_node_id" {
    byte_length = 2
    count = var.instance_count
}

resource "aws_instance" "main_instance"{
    count = var.instance_count
    instance_type = var.instance_type
    ami = data.aws_ami.main_ami.id
    tags = {
        Name = "main-instance-${random_id.main_node_id[count.index].dec}"
    }
    # key_name = ""
    vpc_security_group_ids = [var.public_sg]
    subnet_id = var.public_subnet[count.index]
    # user_data = ""
    root_block_device {
        volume_size = var.vol_size
    }
}