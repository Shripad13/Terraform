# Iteration (0,1,2,3,4,..) number is called as count.index


resource "null_resource" "main" {
  count = 3 # count goes by list each & every iteration is defined by a index number & that many instance will be created
  # here 3 instances will be created with index number 0,1,2
}

resource "null_resource" "fruits" {
  count = length(var.fruits) # here count should be based on no. of fruits declared in variable fruits dynamically 

}

# length function gives the length of the list declared in variable fruits.

variable "fruits" {
  default = ["banana", "apple", "lemon"]
}


# here if you change the order of the fruits in the variable fruits, 
# then the output will also change accordingly as the count is based on the length of the list and the index number is based on the order of the list.
# IF you remove any fruit, then you dont which fruit is removed as the count is based on the length of the list and the index number is based on the order of the list.
# So, it is not recommended to use count with list as it can lead to confusion and errors. It is better to use for_each with map or set to avoid such issues.