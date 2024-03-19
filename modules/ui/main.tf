resource "null_resource" "ui_data" {
  provisioner "local-exec" {
    command  = <<EOT
cp -f sources/ui/template/userprofile.js  sources/ui/js/userprofile.js &&
sed -i "s/variable_to_replace_aws_region/${var.aws_region}/" sources/ui/js/userprofile.js &&
sed -i "s/variable_to_replace_provider_domain_id/${var.provider_domain_id}/" sources/ui/js/userprofile.js &&
sed -i "s|variable_to_replace_domain_url|${var.domain_url}|" sources/ui/js/userprofile.js &&
sed -i "s/variable_to_replace_client_id/${var.client_id}/" sources/ui/js/userprofile.js &&
sed -i "s/variable_to_replace_client_secret/${var.client_secret}/" sources/ui/js/userprofile.js &&
sed -i 's|variable_to_replace_api_endpoint|${var.api_endpoint}|' sources/ui/js/userprofile.js &&
sed -i "s/variable_to_replace_user_pool_id/${var.user_pool_id}/" sources/ui/js/userprofile.js &&
echo 'success update'
EOT
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket        = "${var.s3_id}"
  acl           = "public-read"
  key           = "index.html"
  source        = "sources/ui/index.html"
  etag          = filemd5("sources/ui/index.html")
  content_type  = "text/html"
 
  metadata = {
    "content-type" = "text/html"
  }

  depends_on = [
    null_resource.ui_data
  ]
}

resource "aws_s3_bucket_object" "userprofile" {
  bucket        = "${var.s3_id}"
  acl           = "public-read"
  key           = "js/userprofile.js"
  source        = "sources/ui/js/userprofile.js"
  content_type  = "application/javascript"

  metadata = {
    "content-type" = "application/javascript"
  }

  depends_on = [
    null_resource.ui_data
  ]
}

resource "aws_s3_bucket_object" "verifier" {
  bucket        = "${var.s3_id}"
  acl           = "public-read"
  key           = "js/verifier.js"
  source        = "sources/ui/js/verifier.js"
  etag          = filemd5("sources/ui/js/verifier.js")
  content_type  = "application/javascript"

  metadata = {
    "content-type" = "application/javascript"
  }

  depends_on = [
    null_resource.ui_data
  ]
}