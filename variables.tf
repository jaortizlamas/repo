variable "puerto_servidor" {
  description = "puerto de las instancias"
  type = number
}
variable "puerto_lb" {
  description = "puerto del lb"
  type = number
}
variable "tipo_instancia" {
  description = "tipo de instancia en AWS"
  type = string
}
