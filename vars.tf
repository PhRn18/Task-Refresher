variable "prefix" {
  type    = string
  default = "cleanup"
}

variable "aws-lambda-basic-execution-role" {
  default = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

variable "schedule_expression" {
  default = "cron(0 0 * * ? *)"
}

variable "services" {

  type = list(object({
    cluster_arn = string
    service_arn = string
  }))

  default = [
    {
      cluster_arn = "arn:aws:ecs:us-east-1:123456789012:cluster/my-cluster-1"
      service_arn = "arn:aws:ecs:us-east-1:123456789012:service/my-service-1"
    }
  ]
}

variable "region" {
  default = "us-east-1"
}