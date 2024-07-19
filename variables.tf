variable "puerto_servidor" {
  description = "puerto de las instancias"
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
