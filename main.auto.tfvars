aws_creds = "/Users/davidburkitt/git/repos/terraform/tf_aws_demo_1/.aws/credentials"
aws_region = "us-east-2"

lambda_functions = [
{
  name      = "slackAlert1"
  file      = "/Users/davidburkitt/git/repos/go/slackAlert/main.zip"
  handler   = "main"
  runtime   = "go1.x"
  variables = {"requires" = "override"} # override.tf replaces with valid tuple including Slack webhook to obfuscate from github (override.tf not commited)
  topic = "arn:aws:sns:us-east-2:571562921621:LambdaStarts"
},
]

