data "aws_iam_policy_document" "ecs_scheduler_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_scheduler_lambda" {
  name               = "${var.prefix}ecs_scheduler_lambda"
  assume_role_policy = data.aws_iam_policy_document.ecs_scheduler_lambda.json
}

resource "aws_iam_role_policy_attachment" "ecs_scheduler_lambda_logs" {
  role       = aws_iam_role.ecs_scheduler_lambda.name
  policy_arn = var.aws-lambda-basic-execution-role
}

resource "aws_iam_policy" "ecs_scheduler_lambda" {
  name        = "${var.prefix}ecs_scheduler_lambda"
  description = "Policy for modifying ecs service"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Sid": "Invoke",
           "Effect": "Allow",
           "Action": [
               "ecs:UpdateService"
           ],
           "Resource": ${jsonencode([for service in var.services : service.service_arn])}
       }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_scheduler_lambda_ecs" {
  role       = aws_iam_role.ecs_scheduler_lambda.name
  policy_arn = aws_iam_policy.ecs_scheduler_lambda.arn
}

data "aws_iam_policy_document" "ecs_scheduler" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "scheduler.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_scheduler" {
  name               = "${var.prefix}ecs_scheduler"
  assume_role_policy = data.aws_iam_policy_document.ecs_scheduler.json
}

resource "aws_iam_policy" "ecs_scheduler" {
  name        = "${var.prefix}ecs_scheduler"
  description = "Policy for triggering lambda"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Sid": "Invoke",
           "Effect": "Allow",
           "Action": [
               "lambda:InvokeFunction"
           ],
           "Resource": [
              "${aws_lambda_function.ecs_scheduler.arn}"
           ]
       }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_scheduler" {
  role       = aws_iam_role.ecs_scheduler.name
  policy_arn = aws_iam_policy.ecs_scheduler.arn
}
