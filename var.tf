variable "idx" {
  type = number
  default = 5
}

variable "prefix" {
  type = string
  default = "TF_"
}

variable "domain" {
  type = string
  default = "KP11"
}

locals {
  students = jsondecode(file("students.json"))
}
