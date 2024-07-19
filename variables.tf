variable "puerto_servidor" {
  description = "puerto de las instancias EC2"
  type = any
  default = 8080

  validation {
    condition =  var.puerto_servidor > 0 && var.puerto_servidor <= 65536
    error_message = "Puerto no valido"
  }
}
variable "puerto_lb" {
  description = "puerto del lb"
  type = any
  default = 80
}
variable "tipo_instancia" {
  description = "tipo de instancia en AWS"
  type = any
  default = "t2.micro"
}

variable "ubuntu_ami" {
  type = map(string)
  description = "ami por region"

  default = {
    eu-west-1 = "ami-0aef57767f5404a3c"
    us-west-2 = "ami-05c456ebf5c525b7b"

  }
}