
variable "default_user" {
  type = string
}

variable "key_name" {
  type = string
}

variable "region" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "access_key" {
  type      = string
  sensitive = true
}

variable "secret_key" {
  type      = string
  sensitive = true
}
