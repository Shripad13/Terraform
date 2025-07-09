resource "null_resource" "main"  {
  count = 5
}


resource "null_resource" "main-test"  {
  count = 5
}

# Iteration (0,1,2,3,4,..) number is called as count.inde