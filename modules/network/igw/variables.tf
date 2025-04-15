variable "vpc_id" {
  description = "VPC ID to attach the IGW"
  type        = string
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the IGW"
  type        = map(string)
  default     = {}
}