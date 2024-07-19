variable "puerto_servidor" {
  description = "puerto de las instancias"
  type = any
  default = 8080
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
