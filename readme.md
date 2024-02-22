## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| memory_size| computing function memory size | `number` | 128 | yes |
| kms_key_arn | The KMS key for lambda env encryption | `string` | n/a | yes |
| tags | Tags to apply in all possible resources | `map(string)` | n/a | yes |
| region_shorthand | region shorthand differentiate regions on global resources | `string` | n/a | yes |
| timeout | the amount of time the lambda function will run | `number` | 30 | yes |
| env | To add the correct environment for the resource | `string` | n/a | yes |

## Outputs

No output.


## ChangeLog
### [ cloudwatch_logs_tagging-0.1.0 ] 
 - creating cloudwatch log tag module
