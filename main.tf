    provider "aws" {
        region = local.region
    }

locals {
    region = "eu-west-1"
    ami = var.ubuntu_ami[local.region]
}


terraform {
    backend "s3" {
        bucket = "terraformjaortiz"
        key    = "terraformjaortiz/terraform.tfstate"
        region = "eu-west-1"
        encrypt = true
  }
}
data "aws_subnet" "public_subnet" {
    for_each = var.servidores
    availability_zone = "${local.region}${each.value.az}"
}

#recursos


resource "aws_instance" "servidor" {
    for_each = var.servidores

    ami = local.ami
    instance_type = var.tipo_instancia
    subnet_id = data.aws_subnet.public_subnet[each.key].id //each.key es ser-1 o ser-2
    vpc_security_group_ids = [  aws_security_group.mi_sg.id]
    user_data = <<-EOF
        #!/bin/bash
        echo "Hola amigo desde ${each.value.nombre}!" > index.html
        nohup busybox httpd -f -p ${var.puerto_servidor} &
        EOF
    tags = {
        Name = "mi_server_1"
    }
}

resource "aws_security_group" "mi_sg" {
    name = "mi_servidor_sg"

    ingress {
        security_groups = [aws_security_group.alb.id]
        #cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso alpuerto 8080"
        from_port = var.puerto_servidor
        to_port = var.puerto_servidor
        protocol = "TCP"
    }
}

resource "aws_lb" "alb" {
    load_balancer_type = "application"
    name = "terraform-alb"
    security_groups = [aws_security_group.alb.id]
    #subnets = [data.aws_subnet.az_a.id, data.aws_subnet.az_b.id]
    subnets = [ for subnet in data.aws_subnet.public_subnet : subnet.id ]
}

resource "aws_security_group" "alb" {
    name = "malb-sg"

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso alpuerto 80"
        from_port = var.puerto_lb
        to_port = var.puerto_lb
        protocol = "TCP"
    }
    egress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso alpuerto 8080 de las instancias"
        from_port = var.puerto_servidor
        to_port = var.puerto_servidor
        protocol = "TCP"
    }
}

data "aws_vpc" "default" {
    default = true
}

resource "aws_lb_target_group" "this" {
    name = "terraforms-alb-target-group"
    port = var.puerto_lb
    vpc_id = data.aws_vpc.default.id
    protocol = "HTTP"

    health_check {
        enabled = true
        matcher = "200"
        path = "/"
        port = var.puerto_servidor
        protocol = "HTTP"
    }
}


resource "aws_lb_target_group_attachment"  "servidor"{
    for_each = var.servidores

    target_group_arn = aws_lb_target_group.this.arn
    target_id = aws_instance.servidor[each.key].id
    port = var.puerto_servidor
}

resource "aws_lb_listener" "this" {
    load_balancer_arn = aws_lb.alb.arn
    port = var.puerto_lb
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_lb_target_group.this.arn
        type = "forward"
    }
}
