output "id" {
  value       = aws_s3_bucket.storage.id
  description = "ID of the created s3 storage"
}

output "domain_url" {
  value       = "https://${aws_s3_bucket.storage.bucket_domain_name}"
  description = "url of the website"
}

output "s3_read_policy_arn" {
  #value       = "arn:aws:iam::400101735306:policy/s3_read"
  value       = aws_iam_policy.s3_read.arn
  description = "arn of the policy for read access to the s3 bucket"
}

output "s3_write_policy_arn" {
  #value       = "arn:aws:iam::400101735306:policy/s3_write"    
  value       = aws_iam_policy.s3_write.arn
  description = "arn of the policy for write access to the s3 bucket"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.storage.bucket_regional_domain_name
  description = "Regional URl of the created s3 storage"
}
