

    provider "aws" {
    region = "eu-west-1"
}
terraform {
    backend "s3" {
        bucket = "terraformjaortiz"
        key    = "terraformjaortiz/terraform.tfstate"
        region = "eu-west-1"
        encrypt = true
  }
}


data "aws_subnet" "az_a" {
    availability_zone = "eu-west-1a"
}

data "aws_subnet" "az_b" {
    availability_zone = "eu-west-1b"
}
resource "aws_instance" "mi_servidor_1" {
    ami = var.ubuntu_ami["eu-west-1"]
    instance_type = var.tipo_instancia
    subnet_id = data.aws_subnet.az_a.id
    vpc_security_group_ids = [  aws_security_group.mi_sg.id]
    user_data = <<-EOF
        #!/bin/bash
        echo "Hola amigo desde servidor 1!" > index.html
        nohup busybox httpd -f -p ${var.puerto_servidor} &
        EOF
    tags = {
        Name = "mi_server_1"
    }
}

resource "aws_instance" "mi_servidor_2" {
    ami = var.ubuntu_ami["eu-west-1"]
    instance_type = var.tipo_instancia
    subnet_id = data.aws_subnet.az_b.id
    vpc_security_group_ids = [  aws_security_group.mi_sg.id]
    user_data = <<-EOF
        #!/bin/bash
        echo "Hola desde server 2!" > index.html
        nohup busybox httpd -f -p ${var.puerto_servidor} &
        EOF
    tags = {
        Name = "mi_server_2"
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
    subnets = [data.aws_subnet.az_a.id, data.aws_subnet.az_b.id]
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

resource "aws_lb_target_group_attachment"  "mi_servidor_1"{
    target_group_arn = aws_lb_target_group.this.arn
    target_id = aws_instance.mi_servidor_1.id
    port = var.puerto_servidor
}

resource "aws_lb_target_group_attachment"  "mi_servidor_2"{
    target_group_arn = aws_lb_target_group.this.arn
    target_id = aws_instance.mi_servidor_2.id
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