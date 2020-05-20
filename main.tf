
terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
  version = "~> 2.52"
  shared_credentials_file = var.aws_creds
}

locals {
  override_variables = [{"requires" = "override"}]
}

# Create new role which can be assumed by lambda using STS
resource "aws_iam_role" "lambda_role" {
  count = length(var.lambda_functions)
  name = "lambda_role_${var.lambda_functions[count.index].name}"

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
  /*
  tags = {
      tag-key = "tag-value"
  }
  */
}

# Create an IAM policy which allows CloudWatch access
resource "aws_iam_policy" "lambda_logging_policy" {
  count = length(var.lambda_functions)
  name = "lambda_logging_policy_${var.lambda_functions[count.index].name}"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach the CloudWatch logging policy to the new role
resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attachment" {
  count = length(var.lambda_functions)
  role       = aws_iam_role.lambda_role[count.index].name
  policy_arn = aws_iam_policy.lambda_logging_policy[count.index].arn
  depends_on = [aws_iam_policy.lambda_logging_policy,aws_iam_role.lambda_role]
}

# Attach the LambdaBasicExection policy to the new role
resource "aws_iam_role_policy_attachment" "lambda_basic_exection_policy_attachment" {
  count = length(var.lambda_functions)
  role       = aws_iam_role.lambda_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  depends_on = [aws_iam_role.lambda_role]
}

# Create the lambda function
resource "aws_lambda_function" "lambdaFunction" {
  count = length(var.lambda_functions)
  function_name = var.lambda_functions[count.index].name
  filename      = var.lambda_functions[count.index].file
  //role          = var.lambda_functions[count.index].role
  role = aws_iam_role.lambda_role[count.index].arn
  handler       = var.lambda_functions[count.index].handler

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  # source_code_hash = filebase64sha256(var.lambda_functions[count.index].file)
  runtime = var.lambda_functions[count.index].runtime
  environment {variables = var.lambda_functions[count.index].variables} # overriden to obfuscate Slack wehook URL
  depends_on = [aws_iam_role.lambda_role]
}

# Subsrcibe the lambda function to the target queue
resource "aws_sns_topic_subscription" "sns_lambda_trigger" {
  count     = length(var.lambda_functions)
  topic_arn = var.lambda_functions[count.index].topic
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambdaFunction[count.index].arn
  depends_on = [aws_lambda_function.lambdaFunction]
}

# Add resource policy to the lambda function allowing SNS topic to execute
# When created in the console resource permission policy is automatically added to the Lambda Function
resource "aws_lambda_permission" "sns_trigger_permission" {
  count     = length(var.lambda_functions)
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_functions[count.index].name
  principal     = "sns.amazonaws.com"
  source_arn    = var.lambda_functions[count.index].topic
}



