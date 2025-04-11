# # 관리자용 IAM 사용자 생성
# resource "aws_iam_user" "almagest-admin" {
#   name = "almagest-admin"
# }

# # Terraform 작업용 IAM 사용자 생성
# resource "aws_iam_user" "almagest-terraform" {
#   name = "almagest-terraform"
# }

# # 관리자 그룹 생성
# resource "aws_iam_group" "admin" {
#   name = "admin"
# }

# # DevOps 그룹 생성
# resource "aws_iam_group" "devops" {
#   name = "devops"
# }

# # DevOps 그룹에 사용자 추가
# resource "aws_iam_group_membership" "devops_members" {
#   name = aws_iam_group.devops.name

#   users = [
#     aws_iam_user.almagest-terraform.name
#   ]

#   group = aws_iam_group.devops.name
# }

# # DevOps 정책 정의 - AWS 서비스에 대한 광범위한 접근 권한 부여
# resource "aws_iam_policy" "devops" {
#   name        = "devops"
#   description = "iac, jenkins, cli"
#   policy      = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:*",
#                 "s3:*",
#                 "rds:*",
#                 "dynamodb:*",
#                 "lambda:*",
#                 "iam:GetUser",
#                 "iam:GetGroup",
#                 "iam:GetPolicy",
#                 "iam:GetRole",
#                 "iam:GetRolePolicy",
#                 "iam:GetPolicyVersion",
#                 "iam:ListPolicyVersions",
#                 "iam:ListRolePolicies",
#                 "iam:ListAttachedRolePolicies",
#                 "iam:PassRole",
#                 "cloudwatch:*",
#                 "logs:*",
#                 "cloudformation:*",
#                 "ssm:*",
#                 "ecr:*",
#                 "ecs:*",
#                 "elasticloadbalancing:*",
#                 "autoscaling:*",
#                 "route53:*",
#                 "apigateway:*",
#                 "kms:*",
#                 "secretsmanager:*",
#                 "sts:GetCallerIdentity"
#             ],
#             "Resource": "*"
#         }
#     ]
#   })
# }

# # DevOps 그룹에 정책 연결
# resource "aws_iam_group_policy_attachment" "devops_policy_attachment" {
#   group      = aws_iam_group.devops.name
#   policy_arn = aws_iam_policy.devops.arn
# }

# # 관리자 그룹에 AWS 기본 관리 정책 연결
# resource "aws_iam_group_policy_attachment" "admin_policy_attachment" {
#   group      = aws_iam_group.admin.name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

