# Iteration (0,1,2,3,4,..) number is called as count.index


resource "null_resource" "main"  {
  count = 3                   # count goes by list each & every iteration is defined by a index number
}

resource "null_resource" "fruits"  {
  count = length(var.fruits)                         # here count should be based on no. of fruits declared in variable fruits 
                                 
}

# length function gives the length of the list declared in variable fruits.

variable "fruits" {
  default = ["banana", "lemon"]
}


