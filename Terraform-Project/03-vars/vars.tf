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

variable "sample_map" { 
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

# Accessing a variable from different environment file

variable "env" {}

variable "ins_type" {}

output "env" {
   value = "Current environment is ${var.env} and here we use instance type of  ${var.ins_type}"
}

# Command - terraform init; terraform plan --var-file="dev.tfvars"; terraform apply --var-file="dev.tfvars" -auto-approve; 
# Command - terraform init; terraform plan --var-file="prod.tfvars"; terraform apply --var-file="prod.tfvars" -auto-approve;


variable "city" {}

output "city" {
  value = "${var.city} is my native place"
}

#Values that are declared in *.auto.tfvars file dont have to be mentioned while running tf commands & these will be picked by default.
