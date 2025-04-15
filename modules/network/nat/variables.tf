variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the NAT gateway"
  type        = map(string)
  default     = {}
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}