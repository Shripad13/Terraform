# If you're having data of multiple types, you can use map of maps to declare the variable and then use it in your code. 
#This is a more efficient way of declaring variables when you have multiple data types.
# Declare input with map of maps for the variable fruits
# This is another way of supplying input & this helps in avoiding the need of declaring multiple variabls.

fruits = {
  apple = {
    color = "red"
    taste = "sweet"
    price = 10
    metric = "count"
  }
  banana = {
    color = "yellow"
    taste = "sweet"
    price = 20
    metric = "count"
  }
  lemon = {
    color = "yellow"
    taste = "sour"
    price = 30
    metric = "kg"
  }
}