resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/saffaran/app"      retention_in_days = 30
}

