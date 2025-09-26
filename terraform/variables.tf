variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  type    = string
  default = "saffaran"    }

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
