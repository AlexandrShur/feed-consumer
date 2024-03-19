resource "aws_s3_bucket" "storage" {
  bucket = "${var.id}"
  acl    = "private"

  tags = {
    Name        = "storage"
    Environment = "dev"
  }
  
  website {
    index_document = "index.html"
  }
  
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_iam_policy" "s3_read" {
  name   = "s3_read_v2"
  path   = "/"
  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucketMultipartUploads",
                "s3:GetObjectRetention",
                "s3:GetObjectVersionTagging",
                "s3:ListBucket",
                "s3:GetObjectLegalHold",
                "s3:GetObjectVersionTorrent",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:GetObjectTorrent",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.storage.id}/*",
                "arn:aws:s3:::${aws_s3_bucket.storage.id}"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        }
    ]
}
EOT
}

resource "aws_iam_policy" "s3_write" {
  name   = "s3_write_v2"
  path   = "/"
  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ReplicateObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:PutObjectRetention",
                "s3:DeleteObjectVersion",
                "s3:RestoreObject",
                "s3:PutObjectLegalHold",
                "s3:DeleteObject",
                "s3:PutObjectAcl",
                "s3:ReplicateDelete"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.storage.id}/*"
        }
    ]
}
EOT
}
