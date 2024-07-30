output "instancia_id" {
  description = "valores de todos los ids de las instancias"
  value = [for servidor in aws_instance.servidor : servid.id]
}