resource "null_resource" "main"  {
  count = 5                   # count goes by list each & every iteration is defined by a index number
}



# Iteration (0,1,2,3,4,..) number is called as count.index
