provider "aws" {
  region = var.aws_region
}

# CloudFlare Provider 설정
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# 시크릿 매니저에서 DB 자격 증명 가져오기
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.secret_manager_arn
}

# 가장 최신 스냅샷을 찾는 데이터 소스
# data "aws_db_snapshot" "latest" {
#   db_instance_identifier = var.snapshot_identifier
#   most_recent           = true
# }

# ================================ network

# VPC Module
module "vpc" {
  source = "../../modules/network/vpc"
  vpc_name = var.vpc_name
  cidr_block = var.vpc_cidr
  availability_zones = [var.availability_zone_1, var.availability_zone_2]
  public_subnet_cidrs = [var.public_subnet_cidr_c, var.public_subnet_cidr_a]
  private_subnet_cidrs = [var.private_subnet_cidr_c, var.private_subnet_cidr_a]
  tags = var.vpc_tags
}

# Public Subnet C Module
module "public_subnet_c" {
  source = "../../modules/network/subnet"

  vpc_id = module.vpc.vpc_id
  name = "${var.vpc_name}-public-c"
  cidr_block = var.public_subnet_cidr_c
  availability_zone = var.availability_zone_1
  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-public-c" })
}

# Public Subnet A Module
module "public_subnet_a" {
  source = "../../modules/network/subnet"

  vpc_id = module.vpc.vpc_id
  name = "${var.vpc_name}-public-a"
  cidr_block = var.public_subnet_cidr_a
  availability_zone = var.availability_zone_2
  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-public-a" })
}

# Private Subnet C Module
module "private_subnet_c" {
  source = "../../modules/network/subnet"

  vpc_id = module.vpc.vpc_id
  name = "${var.vpc_name}-private-c"
  cidr_block = var.private_subnet_cidr_c
  availability_zone = var.availability_zone_1
  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-private-c" })
}

# Private Subnet A Module
module "private_subnet_a" {
  source = "../../modules/network/subnet"

  vpc_id = module.vpc.vpc_id
  name = "${var.vpc_name}-private-a"
  cidr_block = var.private_subnet_cidr_a
  availability_zone = var.availability_zone_2
  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-private-a" })
}

# IGW Module
module "igw" {
  source = "../../modules/network/igw"

  vpc_id = module.vpc.vpc_id
  tags   = merge(var.vpc_tags, { Name = "${var.vpc_name}-igw" })
  vpc_name = var.vpc_name
}

# NAT Gateway Module
module "nat_gateway" {
  source = "../../modules/network/nat"

  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.public_subnet_c.subnet_id
  availability_zone = var.availability_zone_1
  vpc_name          = var.vpc_name
  tags              = merge(var.vpc_tags, { Name = "${var.vpc_name}-nat" })
}

# Public Route Table C
module "public_route_table_c" {
  source = "../../modules/network/route_table"

  vpc_id = module.vpc.vpc_id
  subnet_id = module.public_subnet_c.subnet_id

  routes = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = module.igw.igw_id
  }]
  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-public-rt-c" })
}

# Public Route Table A
module "public_route_table_a" {
  source = "../../modules/network/route_table"

  vpc_id = module.vpc.vpc_id
  subnet_id = module.public_subnet_a.subnet_id
  routes = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = module.igw.igw_id
  }]
  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-public-rt-a" })
}

# Private Route Table C
module "private_route_table_c" {
  source = "../../modules/network/route_table"

  vpc_id = module.vpc.vpc_id
  subnet_id = module.private_subnet_c.subnet_id
  routes = [{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = module.nat_gateway.nat_gateway_id
  }]
  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-private-rt-c" })
}

# Private Route Table A
module "private_route_table_a" {
  source = "../../modules/network/route_table"

  vpc_id = module.vpc.vpc_id
  subnet_id = module.private_subnet_a.subnet_id
  routes = [{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = module.nat_gateway.nat_gateway_id
  }]
  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-private-rt-a" })
}

# ================================ security group

# ALB Security Group Module
module "alb_security_group" {
  source = "../../modules/network/security_group"

  vpc_id            = module.vpc.vpc_id
  name              = "${var.vpc_name}-alb-sg"
  description       = "Security group for ALB"
  ingress_rules     = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # CloudFlare IP 범위를 포함
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # CloudFlare IP 범위를 포함
    }
  ]
  tags              = merge(var.vpc_tags, { Name = "${var.vpc_name}-alb-sg" })
}

# EC2 Security Group Module
module "ec2_security_group" {
  source = "../../modules/network/security_group"

  vpc_id            = module.vpc.vpc_id
  name              = "${var.vpc_name}-ec2-sg"
  description       = "Security group for EC2 instances"
  ingress_rules     = [
    {
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      security_groups = [module.alb_security_group.security_group_id]
    },
    {
      from_port       = 9090
      to_port         = 9090
      protocol        = "tcp"
      security_groups = [module.alb_security_group.security_group_id]
    }
  ]
  tags              = merge(var.vpc_tags, { Name = "${var.vpc_name}-ec2-sg" })
}

# ================================ ec2

# EC2 Instance Module
module "service_instance" {
  source = "../../modules/compute/ec2"

  instance_name = "${var.vpc_name}-service"
  instance_type = var.service_instance_type
  subnet_id = module.private_subnet_c.subnet_id
  security_group_ids = [module.ec2_security_group.security_group_id]
  instance_id = var.os_image_id
}

module "sub_instance" {
  source = "../../modules/compute/ec2"
  
  instance_name = "${var.vpc_name}-sub"
  instance_type = var.sub_instance_type
  subnet_id = module.private_subnet_a.subnet_id
  security_group_ids = [module.ec2_security_group.security_group_id]
  instance_id = var.os_image_id
}

# ================================ alb

# ALB Module
module "service_alb" {
  source = "../../modules/compute/alb"

  alb_name = "${var.vpc_name}-alb"
  alb_internal = false
  alb_load_balancer_type = "application"
  alb_security_group_ids = [module.alb_security_group.security_group_id]
  alb_subnet_ids = [module.public_subnet_c.subnet_id, module.public_subnet_a.subnet_id]
  alb_tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-alb" })
  alb_enable_deletion_protection = var.enable_deletion_protection
}

# ALB Listener HTTP Module
module "alb_listener_http" {
  source = "../../modules/compute/alb/listener"

  load_balancer_arn = module.service_alb.load_balancer_arn
  listener_port = 80
  listener_protocol = "HTTP"
  listener_default_action_type = "forward"
  target_group_arn = module.target_group_8080.target_group_arn
}

# ALB Listener HTTPS Module
module "alb_listener_https" {
  source = "../../modules/compute/alb/listener"

  load_balancer_arn = module.service_alb.load_balancer_arn
  listener_port = 443
  listener_protocol = "HTTPS"
  listener_default_action_type = "forward"
  target_group_arn = module.target_group_9090.target_group_arn
  
  certificate_arn = var.certificate_arn
}

# Target Group 8080 Module
module "target_group_8080" {
  source = "../../modules/compute/alb/target_group"

  target_group_name = var.alb_target_groups[0].name
  target_group_port = var.alb_target_groups[0].port
  target_group_protocol = var.alb_target_groups[0].protocol
  target_group_vpc_id = module.vpc.vpc_id
  target_group_target_type = var.alb_target_groups[0].target_type
  target_group_health_check = var.alb_target_groups[0].health_check
  target_group_tags = merge(var.vpc_tags, { Name = var.alb_target_groups[0].name })
}

# Target Group 9090 Module
module "target_group_9090" {
  source = "../../modules/compute/alb/target_group"

  target_group_name = var.alb_target_groups[1].name
  target_group_port = var.alb_target_groups[1].port
  target_group_protocol = var.alb_target_groups[1].protocol
  target_group_vpc_id = module.vpc.vpc_id
  target_group_target_type = var.alb_target_groups[1].target_type
  target_group_health_check = var.alb_target_groups[1].health_check
  target_group_tags = merge(var.vpc_tags, { Name = var.alb_target_groups[1].name })
}

# Target Group Attachment 8080 Module
module "target_group_attachment_8080" {
  source = "../../modules/compute/alb/target_group_attachment"
  target_instance_id = module.service_instance.instance_id
  target_group_port = 8080
  target_group_arn = module.target_group_8080.target_group_arn
}

# Target Group Attachment 9090 Module
module "target_group_attachment_9090" {
  source = "../../modules/compute/alb/target_group_attachment"
  target_instance_id = module.sub_instance.instance_id
  target_group_port = 9090
  target_group_arn = module.target_group_9090.target_group_arn
}


# ================================ rds

# RDS Security Group Module
module "rds_security_group" {
  source = "../../modules/network/security_group"

  vpc_id            = module.vpc.vpc_id
  name              = "${var.vpc_name}-rds-sg"
  description       = "Security group for RDS"
  ingress_rules     = [
    {
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      security_groups = [module.ec2_security_group.security_group_id]
    }
  ]
  tags              = merge(var.vpc_tags, { Name = "${var.vpc_name}-rds-sg" })
}

# RDS Subnet Group Module
module "rds_subnet_group" {
  source = "../../modules/database/rds/subnet_group"

  db_subnet_group_name = "${var.vpc_name}-rds-subnet-group"
  subnet_ids = [module.private_subnet_c.subnet_id, module.private_subnet_a.subnet_id]
  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-rds-subnet-group" })
}

# RDS Instance Module
module "rds_instance" {
  source = "../../modules/database/rds"

  db_identifier = "${var.vpc_name}-rds"
  engine = var.rds_engine
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class

  allocated_storage = var.rds_allocated_storage
  db_username = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["DB_USER"]
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["DB_PASS"]
  db_subnet_group_name = "${var.vpc_name}-rds-subnet-group"
  security_group_ids = [module.rds_security_group.security_group_id]

  subnet_ids = [module.private_subnet_c.subnet_id, module.private_subnet_a.subnet_id]
  secret_manager_arn = var.secret_manager_arn
  db_password_secret_name = var.secret_manager_arn
  
  skip_final_snapshot = var.rds_skip_final_snapshot
  final_snapshot_identifier = "${var.snapshot_identifier}-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  
  tags = { Name = "${var.vpc_name}-rds" }
}


# ================================ s3

# S3 Module
module "shared_s3" {
  source = "../../modules/storage/s3"

  bucket_name = var.bucket_name
  force_destroy = var.force_destroy
  versioning_enabled = var.versioning_enabled
  block_public_access = var.block_public_access
  tags = var.s3_tags
}

# ================================ ecr

# Shared ECR Module
module "shared_ecr" {
  source = "../../shared/ecr"

  repository_name = var.ecr_repository_name
  force_delete = var.ecr_force_delete
  scan_on_push = var.ecr_scan_on_push
  image_tag_mutability = var.ecr_image_tag_mutability
  keep_last_images = var.ecr_keep_last_images
  tags = var.ecr_tags
}


# ================================ route53

# Route53 호스팅 영역 모듈
module "route53" {
  source = "../../modules/network/route53"

  domain_name = var.domain_name
  tags = merge(var.vpc_tags, { Name = "${var.vpc_name}-route53" })
}

# ================================ cloudflare

# CloudFlare DNS 레코드 설정
resource "cloudflare_record" "alb" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "CNAME"
  value   = module.service_alb.dns_name  # ALB DNS 이름으로 직접 연결
  proxied = true  # CloudFlare WAF 활성화
}