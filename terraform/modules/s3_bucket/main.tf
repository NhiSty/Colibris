# main.tf

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "PublicReadGetObject",
        Effect: "Allow",
        Principal: "*",
        Action: [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource: [
          "arn:aws:s3:::${aws_s3_bucket.this.id}",
          "arn:aws:s3:::${aws_s3_bucket.this.id}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}
