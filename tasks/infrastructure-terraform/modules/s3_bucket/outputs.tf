output "bucket_name" {
  value = aws_s3_bucket.main.id
}

output "bucket_url" {
  value = "https://${aws_s3_bucket.main.id}.s3.amazonaws.com"
}
