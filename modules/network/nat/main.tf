# NAT Gateway EIP
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-nat-eip"
  })
}

# NAT Gateway 
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-nat"
  })

  depends_on = [aws_eip.nat_eip]
}

