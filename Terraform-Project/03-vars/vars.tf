# variable "a" {}  ## Example to declare variable

variable "a" {
  default     = "Hello World"   #this is default value of variable
}

output "op" {       #this is how we can declare output variable
    value = var.a   #this is how we can access a variable 
}

#List variable


variable "list" {
  type = list(string)   #this is how we can declare list variable
  default = ["a", "b", "c"]
}

output "list" {
  value = var.list
}

#Map variable (stanadrd variable)

variable "sample map" { 
  default = {
    name = "Shripad"
    type = "DevOps"
    Department = "IT"
    salary = "10000"
  }
}

output "sample.map_output" {  #this is how we can declare output variable
  value = var.sample_map
}

output "sample.map_output_x" {  #this is how we can declare output variable
  value = "${var.sample_map["name"]} is a ${var.sample_map["type"]} and his salary is ${var.sample_map["salary"]}"
}


# Accessing a variable from a file
# If you want to access a variable , you need to declare the empty varibale file.

variable "state" {}

output "state" {
  value = var.state
}


