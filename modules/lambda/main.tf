resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "s3_read" {
  name       = "s3_read"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = "${var.s3_read_policy_arn}"
}

resource "aws_iam_policy_attachment" "s3_write" {
  name       = "s3_write"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = "${var.s3_write_policy_arn}"
}

module "source_read" {
  source = "./source_read"

  s3_id               = "${var.s3_id}"
  api_id              = "${var.api_id}"
  authorizer_id       = "${var.authorizer_id}"
  account_id          = "${var.account_id}"
  aws_region          = "${var.aws_region}"
  lambda_iam_role_arn = aws_iam_role.iam_for_lambda.arn
}

module "source_write" {
  source = "./source_write"

  s3_id               = "${var.s3_id}"
  api_id              = "${var.api_id}"
  authorizer_id       = "${var.authorizer_id}"
  account_id          = "${var.account_id}"
  aws_region          = "${var.aws_region}"
  lambda_iam_role_arn = aws_iam_role.iam_for_lambda.arn
}

module "source_process" {
  source = "./source_process"

  s3_id               = "${var.s3_id}"
  account_id          = "${var.account_id}"
  aws_region          = "${var.aws_region}"
  lambda_iam_role_arn = aws_iam_role.iam_for_lambda.arn
}
