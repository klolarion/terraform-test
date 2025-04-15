# EC2 인스턴스
resource "aws_instance" "app" {
  ami           = "ami-0c9c942bd7bf113a2"  # Ubuntu 24.04 LTS (ap-northeast-2)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1.id

  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = "app-instance"
  }
}

# ALB 타겟 그룹 생성 (8080 포트)
resource "aws_lb_target_group" "app_8080" {
  name     = "app-tg-8080"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/aaa/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# ALB 타겟 그룹 생성 (9090 포트)
resource "aws_lb_target_group" "app_9090" {
  name     = "app-tg-9090"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/bbb/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# ALB 생성
resource "aws_lb" "app" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [
    aws_subnet.public_subnet_c.id,
    aws_subnet.public_subnet_a.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "app-alb"
  }
}

# ALB 리스너 생성 (HTTP)
resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ALB 리스너 생성 (HTTPS)
resource "aws_lb_listener" "app_https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.main.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

# 경로 기반 라우팅 규칙 (/aaa -> 8080)
resource "aws_lb_listener_rule" "aaa" {
  listener_arn = aws_lb_listener.app_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_8080.arn
  }

  condition {
    path_pattern {
      values = ["/aaa", "/aaa/*"]
    }
  }
}

# 경로 기반 라우팅 규칙 (/bbb -> 9090)
resource "aws_lb_listener_rule" "bbb" {
  listener_arn = aws_lb_listener.app_https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_9090.arn
  }

  condition {
    path_pattern {
      values = ["/bbb", "/bbb/*"]
    }
  }
}

# 타겟 그룹에 EC2 인스턴스 연결 (8080)
resource "aws_lb_target_group_attachment" "app_8080" {
  target_group_arn = aws_lb_target_group.app_8080.arn
  target_id        = aws_instance.app.id
  port             = 8080
}

# 타겟 그룹에 EC2 인스턴스 연결 (9090)
resource "aws_lb_target_group_attachment" "app_9090" {
  target_group_arn = aws_lb_target_group.app_9090.arn
  target_id        = aws_instance.app.id
  port             = 9090
}






# RDS 서브넷 그룹
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "main-db-subnet-group"
  }
}

# RDS DB 인스턴스 생성
resource "aws_db_instance" "main" {
  identifier           = "terraform-rds"
  engine              = "postgres"
  engine_version      = "17.2"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username           = "root"
  password           = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["DB_PASS"]
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  
  # 스냅샷 설정
  snapshot_identifier = var.restore_from_snapshot && length(data.aws_db_snapshot.latest) > 0 ? data.aws_db_snapshot.latest.db_snapshot_identifier : null
  skip_final_snapshot = false
  final_snapshot_identifier = "terraform-backup-${formatdate("YYYYMMDD-hhmmss", timestamp())}"

  tags = {
    Name = "terraform-rds"
  }

  # VPC 설정만 무시
  lifecycle {
    ignore_changes = [
      vpc_security_group_ids,
      db_subnet_group_name
    ]
  }
}

# CloudFlare DNS 레코드 설정
resource "cloudflare_record" "alb" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "CNAME"
  content = aws_lb.app.dns_name
  proxied = true
}


