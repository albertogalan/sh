locals {
  unique_name = var.name
  tags          = local.common_tags
}

resource "time_static" "deployment" {}

resource "aws_s3_bucket" "this" {
  bucket = var.s3_name
}

output "name" {
  description = "The name of the stack."
  value       = aws_s3_bucket.this
}

