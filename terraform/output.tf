output "ec2_instance_public_ip" {
  value       = module.ec2_instance.instance_public_ip
  description = "The public IP address of the EC2 instance created by the module"
}

output "ssh_command" {
  value = "ssh -i ${var.private_key_path} ${var.ssh_user}@${module.ec2_instance.instance_public_ip}"
  description = "Command to connect to the instance via SSH"
}

output "bucket_website_url" {
  description = "The website URL of the bucket"
  value       = module.s3_bucket.bucket_website_url
}