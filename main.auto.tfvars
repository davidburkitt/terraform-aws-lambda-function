aws_creds = "/Users/davidburkitt/git/repos/terraform/tf_aws_demo_1/.aws/credentials"
aws_region = "us-east-2"

lambda_functions = [
{
  name      = "slackLambdaDurationAlert"
  file      = "/Users/davidburkitt/git/repos/go/slackAlert/main.zip"
  handler   = "main"
  runtime   = "go1.x"
  variables = {"SLACK_WEBHOOK" = "https://hooks.slack.com/services/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"}
  topic = "arn:aws:sns:us-east-2:571562921621:LambdaDuration"
},
]

