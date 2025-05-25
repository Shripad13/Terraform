# Declaring as empty variables

variable "fruits" {}

output "apple_op" {
    value = "Apples are ${var.fruits["apple"]["color"]} is a ${var.fruits["apple"]["taste"]} fruit and its price is ${var.fruits["apple"]["price"]} ${var.fruits["apple"]["metric"]}"
}

output "banana_op" {
    value = "Bananas are ${var.fruits["banana"]["color"]} is a ${var.fruits["banana"]["taste"]} fruit and its price is ${var.fruits["banana"]["price"]} ${var.fruits["banana"]["metric"]}"
}  

output "lemon_op" {
    value = "Lemons are ${var.fruits["lemon"]["color"]} is a ${var.fruits["lemon"]["taste"]} fruit and its price is ${var.fruits["lemon"]["price"]} ${var.fruits["lemon"]["metric"]}"
}
