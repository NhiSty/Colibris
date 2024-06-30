variable "aws_region" {
  description = "The AWS region to deploy resources into"
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "The type of instance to use"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
}

variable "private_key_path" {
  description = "Path to the private SSH key"
}

variable "public_key_path" {
  description = "Path to the public SSH key file"
}

variable "ssh_user" {
  description = "SSH user to access EC2 instance"
  default     = "ubuntu"
}

variable "script_path" {
  description = "Path to the shell script to be executed on the instance"
  default = "./setup.sh"
}

variable "tags" {
  description = "A map of tags to add to the EC2 instance"
  type        = map(string)
  default     = {}
}

variable "key_name" {
  description = "The name of the AWS key pair to be used with the EC2 instance"
  type        = string
}


variable "security_group_id" {
  description = "The ID of the security group to be associated with the EC2 instance"
  type        = string
}
