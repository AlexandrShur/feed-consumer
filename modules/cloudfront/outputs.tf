output "distribution_url" {
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
  description = "url of the created cloudfront distribution"
}
