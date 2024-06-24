resource "aws_security_group" "main" {
  name        = "main-security-group"
  description = "Security group for main application with minimal access"

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH access from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Web application access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MainSecurityGroup For Go App"
  }
}


resource "aws_key_pair" "aws_key_ec2" {
  key_name   = "aws-ssh-key"
  public_key = file(var.public_key_path)
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  aws_region = var.aws_region
  instance_type = "t2.micro"
  ami_id = "ami-00ac45f3035ff009e"
  private_key_path = var.private_key_path
  public_key_path =  var.public_key_path
  ssh_user = "ubuntu"
  script_path = "modules/ec2_instance/setup.sh"
  tags = {
    Name        = "MyInstance - Go App"
    Environment = "Production"
  }
  key_name = aws_key_pair.aws_key_ec2.key_name 
  security_group_id = aws_security_group.main.id
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
  bucket_name = "colibris"
  tags = {
    Name        = "My bucket - Flutter App"
    Environment = "Production"
  }
}