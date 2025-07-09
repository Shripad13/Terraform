 
module "sample" {
    source = "./sample-module" # Source can be from Tf Registry path, local path, or Github repo
    fruits = var.fruits
}


output "test" {
    value = module.sample.fruits
}