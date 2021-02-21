# Client web

resource "aws_s3_bucket" "web-client" {
  bucket = "${var.APP_NAME}-${var.ENV}-web-client"
  acl    = "public-read"
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

# Admin web

resource "aws_s3_bucket" "web-admin" {
  bucket = "${var.APP_NAME}-${var.ENV}-web-admin"
  acl    = "public-read"
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

# File bucket

resource "aws_s3_bucket" "file-bucket" {
  bucket = "${var.APP_NAME}-${var.ENV}-files"
  acl    = "private"

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-files"
  }
}