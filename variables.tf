variable "aws_creds" {
  type        = string
  description = "path to AWS secret and key"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "lambda_functions" {
  type = list(object({
    name      = string # function name
    file      = string # zipped application package
    handler   = string # handler within function (e.g. main for GO)
    runtime   = string # runtime [dotnetcore1.0 dotnetcore2.0 dotnetcore2.1 dotnetcore3.1 go1.x java8 java11 nodejs4.3 nodejs4.3-edge nodejs6.10 nodejs8.10 nodejs10.x nodejs12.x provided python2.7 python3.6 python3.7 python3.8 ruby2.5 ruby2.7]
    variables = map(string) # environment variables
    topic     = string # SNS topic ARN
  }))
}

