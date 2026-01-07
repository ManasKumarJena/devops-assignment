terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# -------------------------------------------------
# IAM ROLE FOR EC2 (SSM + PARAMETER STORE)
# -------------------------------------------------
resource "aws_iam_role" "ec2_role" {
  name = "devops-assignment-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach SSM core policy
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Custom policy to read SSM Parameter
resource "aws_iam_policy" "ssm_read_secret" {
  name = "devops-assignment-ssm-read-secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = aws_ssm_parameter.app_secret.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ssm_secret_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ssm_read_secret.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "devops-assignment-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# -------------------------------------------------
# SSM PARAMETER STORE (SECRET)
# -------------------------------------------------
resource "aws_ssm_parameter" "app_secret" {
  name  = "/devops-assignment/app/SECRET_KEY"
  type  = "SecureString"
  value = "my-super-secret-value"
}

# -------------------------------------------------
# SECURITY GROUP
# -------------------------------------------------
resource "aws_security_group" "app_sg" {
  name        = "devops-assignment-sg"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------------------------------
# EC2 INSTANCE
# -------------------------------------------------
resource "aws_instance" "app_ec2" {
  ami                    = "ami-03f4878755434977f" # Amazon Linux 2 (ap-south-1)
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "devops-assignment"
  }
}
