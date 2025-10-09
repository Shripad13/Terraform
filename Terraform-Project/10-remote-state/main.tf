# Create a s3 bucket to store the terraform state file

resource "null_resource" "main" {}

provider "aws" { }

terraform {
    backend "s3" {
        bucket = "devsecopswithshri-terraform-state"
        key    = "dev/terraform.tfstate"
        region = "us-east-1"
    }
}