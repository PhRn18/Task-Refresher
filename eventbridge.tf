resource "aws_scheduler_schedule" "ecs_scheduler_start" {
  count = length(var.services)

  name = "${var.prefix}${reverse(split("/", var.services[count.index].cluster_arn))[0]}_${reverse(split("/", var.services[count.index].service_arn))[0]}_start"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.schedule_expression

  target {
    arn      = aws_lambda_function.ecs_scheduler.arn
    role_arn = aws_iam_role.ecs_scheduler.arn
    input = jsonencode({
      cluster = var.services[count.index].cluster_arn,
      service = var.services[count.index].service_arn
    })
  }
}

