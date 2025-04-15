variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "name" {
  description = "Security group name"
  type        = string
}

variable "description" {
  description = "Security group description"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
  }))
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
} 