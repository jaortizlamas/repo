resource "aws_lb" "alb" {
    load_balancer_type = "application"
    name = "terraform-alb"
    security_groups = [aws_security_group.alb.id]
    #subnets = [data.aws_subnet.az_a.id, data.aws_subnet.az_b.id]
    subnets = var.subnet_ids
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
    #for_each = var.instancias_ids
    count = length(var.instancias_ids)

    target_group_arn = aws_lb_target_group.this.arn
    target_id = element(var.instancias_ids, count.index)
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
