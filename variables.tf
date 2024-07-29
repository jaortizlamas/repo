variable "puerto_servidor" {
  description = "puerto de las instancias EC2"
  type = number
  default = 8080

}
variable "puerto_lb" {
  description = "puerto del lb"
  type = number
  default = 80
}
variable "tipo_instancia" {
  description = "tipo de instancia en AWS"
  type = string
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

variable "servidores" {
  description = "mapa de servidores con nombres y AZs"
  type = map(object({
    nombre = string,
    az = string

  }))
  default = {
    "ser-1" = { nombre = "servidor-1", az = "a" }
    "ser-2" = { nombre = "servidor-2", az = "b" }
    "ser-3" = { nombre = "servidor-3", az = "c" }
  }
}