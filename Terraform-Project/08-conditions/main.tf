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