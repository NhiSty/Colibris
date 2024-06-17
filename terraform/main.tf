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

resource "aws_instance" "vm" {
  ami                         = var.ami
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.security_group_vm.name]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.aws-key-pair.key_name
  vpc_security_group_ids      = [aws_security_group.security_group_vm.id]

  user_data = <<-EOF
    #!/bin/bash

    exec > /var/log/user-data.log 2>&1
    set -x

    chmod +x "$0"
    if ! [ -x "$(command -v docker)" ]; then
        sudo apt update
        sudo apt-get -y install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update

        sudo apt-get install -y  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo apt install -y git
        sudo usermod -aG docker "$USER"
     
      exit 1
    fi

    if [ -d "Colibris" ]; then
      echo "Le dossier Colibris existe déjà"
    else
      git clone https://github.com/NhiSty/Colibris.git
    fi

    cd Colibris/Back
    cp .env.example .env
    git checkout feat/cd
    sudo docker compose -f docker-nginx-proxy-compose.yml up -d --build
    sudo docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
  EOF

  tags = {
    Name = "vm"
  }
}



output "public_ip" {
  value = aws_instance.vm.public_ip
}

