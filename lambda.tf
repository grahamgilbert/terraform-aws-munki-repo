resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.prefix}_iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "template_file" "basic_auth_js" {
  template = "${file("${path.module}/basic_auth.js.tpl")}"

  vars = {
    username = "${var.username}"
    password = "${var.password}"
  }
}

data "archive_file" "basic_auth_lambda_zip" {
  type = "zip"

  output_path             = "basic_auth_lambda.zip"
  source_content          = "${data.template_file.basic_auth_js.rendered}"
  source_content_filename = "basic_auth.js"
}

resource "aws_lambda_function" "basic_auth_lambda" {
  provider         = "aws.use1"
  filename         = "basic_auth_lambda.zip"
  function_name    = "${var.prefix}_basic_auth"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "basic_auth.handler"
  source_code_hash = "${data.archive_file.basic_auth_lambda_zip.output_base64sha256}"
  runtime          = "nodejs10.x"

  publish = true
}
