# Create a s3 bucket to store the terraform state file

resource "null_resource" "main" {}     # Dummy resource to initialize the provider block

# 2nd Dummy resource to initialize the provider block, to check for versioning of s3 bucket 
resource "null_resource" "bar" {}       

# 3rd Dummy resource to initialize the provider block, to check for versioning of s3 bucket 
resource "null_resource" "foo" {} 

provider "aws" { }

terraform {
    backend "s3" {
        bucket = "devsecopswithshri-terraform-state"
        key    = "dev/terraform.tfstate"
        region = "us-east-1"
    }
}