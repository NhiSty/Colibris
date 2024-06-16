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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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
  tags = {
    Name = "terraform-vm"
  }
}



output "public_ip" {
  value = aws_instance.vm.public_ip
}

output "private_key" {
  value = nonsensitive(tls_private_key.kp.private_key_pem)
}
