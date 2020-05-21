output "lambda_functions_output" {
  value = "${formatlist("%v", aws_lambda_function.lambda_function.*.arn)}"
  description = "formatted list of lambda functions"
}

