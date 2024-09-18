//inputs
variable "subnet_ids" {
  description = "Todos los ids de las subnets"
  type = set(string)
}

variable "instancias_ids" {
  description = "Todos los ids de las instancias EC2"
  type = list(string)
}

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