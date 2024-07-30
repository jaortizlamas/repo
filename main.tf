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

module "servidores_ec2" {
  source = "./modulos/instancias-ec2"

  puerto_servidor = 8080
  tipo_instancia = "t2.micro"
  ami_id = local.ami
  servidores = {
    for id_ser, datos in var.servidores :
    id_ser => { nombre = datos.nombre, subnet_id = data.aws_subnet.public_subnet[id_ser].id}
      }
}

module "loadbalancer" {
  source = "./modulos/loadbalancer"
  subnet_ids = [for subnet in data.aws_subnet.public_subnet : subnet.id]
  instancias_ids = module.servidores_ec2.instancias_ids
  puerto_lb = 80
  puerto_servidor = 8080
}