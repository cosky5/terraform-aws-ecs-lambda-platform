resource "aws_sqs_queue" "this" {
  name                       = "${var.project_name}-${var.environment}-events"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600

  tags = {
    Name        = "${var.project_name}-${var.environment}-events"
    Project     = var.project_name
    Environment = var.environment
  }
}