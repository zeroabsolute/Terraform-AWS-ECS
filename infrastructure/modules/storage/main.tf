# Client web

resource "aws_s3_bucket" "web-client" {
  bucket        = "${var.APP_NAME}-${var.ENV}-web-client"
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-web-client"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_policy" "web-client-bucket-policy" {
  bucket = aws_s3_bucket.web-client.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${var.APP_NAME}-${var.ENV}-web-client-policy"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.web-client.arn}/*"]
      },
    ]
  })
}

# Admin web

resource "aws_s3_bucket" "web-admin" {
  bucket        = "${var.APP_NAME}-${var.ENV}-web-admin"
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-web-admin"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_policy" "web-admin-bucket-policy" {
  bucket = aws_s3_bucket.web-admin.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${var.APP_NAME}-${var.ENV}-web-admin-policy"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.web-admin.arn}/*"]
      },
    ]
  })
}

# File bucket

resource "aws_s3_bucket" "file-bucket" {
  bucket = "${var.APP_NAME}-${var.ENV}-files"
  acl    = "private"

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-files"
  }
}
