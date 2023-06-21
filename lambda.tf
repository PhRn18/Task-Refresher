data "archive_file" "ecs_scheduler" {
  type        = "zip"
  output_path = "${path.module}/.ecs_scheduler.zip"
  source {
    content  = <<EOF
import boto3


def lambda_handler(event, context):
    cluster = event.get("cluster")
    service = event.get("service")

    client = boto3.client("ecs")

    client.update_service(
        cluster=cluster,
        service=service,
        forceNewDeployment=True
    )
EOF
    filename = "main.py"
  }
}

resource "aws_lambda_function" "ecs_scheduler" {
  filename         = data.archive_file.ecs_scheduler.output_path
  source_code_hash = data.archive_file.ecs_scheduler.output_base64sha256
  function_name    = "${var.prefix}ecs_scheduler"
  role             = aws_iam_role.ecs_scheduler_lambda.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.9"
}


