variable "fruits" {
    default = {
        apple ={
            colour = "RED"
            taste  = "sweet"
            price = 100
            metric = "kg"
        }
        grapes = {
            colour = "GREEN"
            taste  = "sour"
            price = 200
            metric = "kg"
        }
        blackberry = {
            colour = "BLACK"
            taste  = "sour"
            price = 300
            metric = "kg"
            country = "India"
        }
    }
}

resource null_resource "main" {
    for_each = var.fruits
  
}