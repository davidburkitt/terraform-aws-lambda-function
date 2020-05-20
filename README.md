## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.52 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.52 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_creds | path to AWS secret and key | `string` | n/a | yes |
| aws\_region | aws region | `string` | n/a | yes |
| lambda\_functions | n/a | <pre>list(object({<br>    name      = string # function name<br>    file      = string # zipped application package<br>    handler   = string # handler within function (e.g. main for GO)<br>    runtime   = string # runtime [dotnetcore1.0 dotnetcore2.0 dotnetcore2.1 dotnetcore3.1 go1.x java8 java11 nodejs4.3 nodejs4.3-edge nodejs6.10 nodejs8.10 nodejs10.x nodejs12.x provided python2.7 python3.6 python3.7 python3.8 ruby2.5 ruby2.7]<br>    variables = map(string) # environment variables<br>    topic     = string # SNS topic ARN<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_metric\_alarm | formatted list of lambda functions |

