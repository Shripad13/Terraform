

# Declaring an empty variable
variable "fruits" {}


# nslookup(map, "key", "value")
output "apple_opx" {
  value = "Apples are ${lookup(var.fruits["apple"], "colour", "GREEN")} and their state of origin is ${lookup(var.fruits["apple"], "state", "HimachalPradesh")}"
}

output "grapes_opx" {
  value = "Grapes are ${lookup(var.fruits["grapes"], "colour", "RED")} and their state of origin is ${lookup(var.fruits["grapes"], "state", "UttarPradesh")}"
}