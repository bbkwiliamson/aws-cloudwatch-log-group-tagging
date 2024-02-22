variable tags {
  description =  "Tags to apply in all possible resources"
  type        =  map(string)
}

variable env {
  type =  string
}

variable timeout {
  type        =  number
  default     =  30
  description =  "the amount of time the lambda function will run "
}

variable memory_size {
  type        =  number
  default     =  128
  description = "computing function memory size"
}

variable kms_key_arn {
  type        = string
  description = "The KMS key for lambda env encryption"
}

variable "region_shorthand" {
   type        = string
   default     = ""
   description = "region shorthand differentiate regions on global resources"
}
