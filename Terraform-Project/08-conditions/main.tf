#SYNTAX - condition ? true_val : false_val
# Example: score > 70 ? "You Passed in exam" : "You failed in Exam"
# If score is greater than 70 then it will return "You Passed in exam" otherwise it will return "You failed in Exam"


variable "score" {
  description = "Score of the student"
  default     = 65
}

output "score" {
  value = var.score
}

output "score_x" {
  value = var.score > 70 ? "You Passed in exam" : "You failed in Exam"
}


provider "aws" { }

resource "aws_instance" "main" {
  ami           = "ami-0fcc78c828f981df2" # N.Virginia AMI
  instance_type = var.env == "dev" ? "t2.micro" : "t3.medium"
    tags = {
        Name = "TerraformConditionalInstance"
    }

}

variable "env" {
  default = "prod"
}