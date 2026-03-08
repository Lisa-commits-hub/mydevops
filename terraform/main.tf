terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s-security-group"
  description = "Security group for Kubernetes nodes"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "k8s-security-group"
  }
}

resource "aws_instance" "k8s_control_plane" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.medium"
  key_name               = "devops-key"
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "k8s-control-plane"
  }
}

resource "aws_instance" "k8s_worker_1" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.medium"
  key_name               = "devops-key"
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "k8s-worker-1"
  }
}

output "k8s_control_plane_ip" {
  value = aws_instance.k8s_control_plane.public_ip
}

output "k8s_worker_1_ip" {
  value = aws_instance.k8s_worker_1.public_ip
}
