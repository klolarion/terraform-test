# Public 라우트 테이블 생성
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
      nat_gateway_id = route.value.nat_gateway_id
    }
  }

  tags = var.tags
}

# Public 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "association" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.route_table.id
}