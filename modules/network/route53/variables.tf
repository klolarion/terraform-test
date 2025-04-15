variable "domain_name" {
  description = "도메인 이름"
  type        = string
}

variable "tags" {
  description = "리소스 태그"
  type        = map(string)
  default     = {}
} 