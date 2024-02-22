resource aws_cloudwatch_event_rule LogGroup_Scheduled_tag {
  name                = "LogGroup_Scheduled_tag_${var.env}"
  description         = "Scheduled tagging for Cloudwatch log groups"
  schedule_expression = "cron(0 6 25 * ? *)"
}

resource aws_cloudwatch_event_rule New_logGroup_tag {
  name                 = "New_logGroup_tag_${var.env}"
  description          = "Create cloudwatch log group event tagging"
  event_pattern = <<EOF
  {
    "source":[
      "aws.logs"
    ],
    "detail":{
        "eventSource":[
          "logs.amazonaws.com"
      ],
        "eventName":[
          "CreateLogGroup"
      ]
    }
  }
  EOF
}



resource aws_cloudwatch_event_target LogGroup_Scheduled_tag {
  rule      = aws_cloudwatch_event_rule.LogGroup_Scheduled_tag.name
  target_id = "Cloudwatch_LogGroup_Scheduled_tag"
  arn       = aws_lambda_function.Cloudwatch_Log_tag.arn
}

resource aws_cloudwatch_event_target New_logGroup_tag {
  rule      = aws_cloudwatch_event_rule.New_logGroup_tag.name
  target_id = "Cloudwatch_New_logGroup_tag"
  arn       = aws_lambda_function.Cloudwatch_Log_tag.arn
}

resource aws_lambda_permission LogGroup_Scheduled_tag {
  statement_id  = "ExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Cloudwatch_Log_tag.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.LogGroup_Scheduled_tag.arn
}

resource aws_lambda_permission New_logGroup_tag {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Cloudwatch_Log_tag.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.New_logGroup_tag.arn
}

