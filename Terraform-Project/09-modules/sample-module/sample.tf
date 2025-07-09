
resource "null_resource" "main" {
    count = lenght(var.fruits)
}

variable "fruits" {}

output "test" {
    value = "hello World"
}