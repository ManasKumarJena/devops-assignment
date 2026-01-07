provider "aws" {
  region = "ap-south-1"
}

# 🔁 Reuse existing IAM role (DO NOT recreate)
data "aws_iam_role" "ec2_role" {
  name = "ec2-secrets-role"
}

# 🔐 Attach Secrets Manager policy (safe even if already attached)
resource "aws_iam_role_policy_attachment" "secrets" {
  role       = data.aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# 🔁 Reuse / create instance profile safely
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = data.aws_iam_role.ec2_role.name
}

resource "aws_instance" "app" {
  ami                  = "ami-0f58b397bc5c1f2e8"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name             = var.key_name

  user_data = <<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -aG docker ec2-user
EOF

  tags = {
    Name = "devops-assignment"
  }
}
