output "instancias_ids" {
  description = "valores de todos los ids de las instancias"
  value = [for servidor in aws_instance.servidor : servidor.id]
}