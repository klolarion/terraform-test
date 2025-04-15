variable "vpc_id" {
  description = "라우트 테이블이 생성될 VPC의 ID"
  type        = string
}

variable "subnet_id" {
  description = "라우트 테이블과 연결될 서브넷 ID"
  type        = string
}

variable "routes" {
  description = "라우트 테이블에 추가할 라우트 목록"
  type = list(object({
    cidr_block     = string
    gateway_id     = optional(string)
    nat_gateway_id = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "라우트 테이블에 적용할 태그"
  type        = map(string)
  default     = {}
}







