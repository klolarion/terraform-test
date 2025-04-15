# ECR 설정
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "force_delete" {
  description = "Whether to force delete the repository even if it contains images"
  type        = bool
  default     = false
}

variable "scan_on_push" {
  description = "Whether to scan images on push"
  type        = bool
  default     = true
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "keep_last_images" {
  description = "Number of images to keep in the repository"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to the repository"
  type        = map(string)
  default     = {}
}