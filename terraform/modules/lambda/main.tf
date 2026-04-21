data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.lambda_source_dir
  output_path = "${path.module}/lambda_payload.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-${var.environment}-${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "sqs_access" {
  name = "${var.project_name}-${var.environment}-${var.function_name}-sqs-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = var.queue_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sqs_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.sqs_access.arn
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}-${var.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "this" {
  function_name    = "${var.project_name}-${var.environment}-${var.function_name}"
  role             = aws_iam_role.lambda_exec.arn
  runtime          = "python3.12"
  handler          = "handler.handler"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      QUEUE_NAME = var.queue_name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.this
  ]
}