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


  connection {
    type        = "ssh"
    user        = var.default_user
    private_key = tls_private_key.kp.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "./deploy.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/script.sh ./",
      "sudo chmod 777 ./script.sh",
      "sudo ./script.sh"
    ]
  }

  tags = {
    Name = "vm"
  }
}



output "public_ip" {
  value = aws_instance.vm.public_ip
}

output "private_key" {
  value = nonsensitive(tls_private_key.kp.private_key_pem)
}
