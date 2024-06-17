terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = var.region
}

resource "tls_private_key" "kp" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "aws-key-pair" {
  key_name   = var.key_name
  public_key = tls_private_key.kp.public_key_openssh
}


resource "aws_security_group" "security_group_vm" {
  name = var.security_group_name

  ingress {
    from_port   = 22
    to_port     = 22
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
    from_port   = 443
    to_port     = 443
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

data "template_file" "deploy" {
  template = file("./deploy.sh")
}

resource "aws_eip" "ip" {
  instance = aws_instance.vm.id
  domain   = "vpc"
}

resource "aws_vpc" "vpc" {
  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_instance" "vm" {
  ami                    = var.ami
  instance_type          = var.instance_type
  security_groups        = [aws_security_group.security_group_vm.name]
  subnet_id              = aws_subnet.subnet.id
  key_name               = aws_key_pair.aws-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.security_group_vm.id]
  user_data              = data.template_file.deploy.rendered

}



output "public_ip" {
  value = aws_instance.vm.public_ip
}

