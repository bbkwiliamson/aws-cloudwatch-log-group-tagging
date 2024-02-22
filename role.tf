resource aws_iam_role Bounded_tag_logGroup {
  path                 = "/"
  name                 = "Bounded_tag_logGroup_${var.region_shorthand == "" ? "" : "${var.region_shorthand}_"}${var.env}"
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/BoundedPermissionsPolicy"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume.json
  tags                 = var.tags
}

resource aws_iam_role_policy_attachment Bounded_tag_logGroup {
  role =  aws_iam_role.Bounded_tag_logGroup.name
  policy_arn =  aws_iam_policy.Bounded_tag_logGroup.arn
}

resource aws_iam_policy Bounded_tag_logGroup {
  name        =  "Bounded_tag_logGroup_${var.region_shorthand == "" ? "" : "${var.region_shorthand}_"}${var.env}"
  policy      =  data.aws_iam_policy_document.Bounded_tag_logGroup.json
}

data aws_iam_policy_document lambda_assume {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data aws_iam_policy_document Bounded_tag_logGroup {

  statement {  
    sid = "CloudwatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:ListTagsLogGroup",
      "logs:TagLogGroup",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"]
  }
}  

