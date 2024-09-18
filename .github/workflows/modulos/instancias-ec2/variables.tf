variable "puerto_servidor" {
  description = "puerto de las instancias EC2"
  type = number
  default = 8080

}

variable "tipo_instancia" {
  description = "tipo de instancia en AWS"
  type = string

}

variable "ami_id" {
  description = "identificador de la ami"
  type = string
}

variable "servidores" {
  description = "mapa de servidores con nombres y AZs"
  type = map(object({
    nombre = string,
    subnet_id = string
  }))
 
}