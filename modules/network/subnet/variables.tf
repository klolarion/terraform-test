variable "name" {
  description = "Subnet name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cidr_block" {
  description = "서브넷의 CIDR 블록"
  type        = string
}

variable "availability_zone" {
  description = "서브넷이 생성될 가용 영역"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "서브넷에 생성되는 인스턴스에 자동으로 퍼블릭 IP 할당 여부"
  type        = bool
  default     = false
}

variable "tags" {
  description = "서브넷에 적용할 태그"
  type        = map(string)
  default     = {}
}









