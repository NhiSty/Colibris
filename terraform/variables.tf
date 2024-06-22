variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "eu-west-3"
}

variable "public_key_path" {
  description = "SSH public key to use for the EC2 key pair"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private SSH key"
  type        = string
}

variable "ssh_user" {
  description = "SSH user to access EC2 instance"
  type        = string
  default     = "ubuntu"
}