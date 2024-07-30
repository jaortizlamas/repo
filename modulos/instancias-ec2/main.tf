resource "aws_instance" "servidor" {
    for_each = var.servidores

    ami = var.ami_id
    instance_type = var.tipo_instancia
    subnet_id = each.value.subnet_id //each.key es ser-1 o ser-2
    vpc_security_group_ids = [  aws_security_group.mi_sg.id]
    user_data = <<-EOF
        #!/bin/bash
        echo "Hola amigo desde ${each.value.nombre}!" > index.html
        nohup busybox httpd -f -p ${var.puerto_servidor} &
        EOF
    tags = {
        Name = each.value.nombre
    }
}

resource "aws_security_group" "mi_sg" {
    name = "mi_servidor_sg"

    ingress {
        #security_groups = [aws_security_group.alb.id]
        cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso alpuerto 8080"
        from_port = var.puerto_servidor
        to_port = var.puerto_servidor
        protocol = "TCP"
    }
}
