output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_website_url" {
  description = "The website URL of the bucket"
  value       = aws_s3_bucket_website_configuration.this.website_endpoint
}