resource "aws_lambda_function" "nextjs_on_lambda" {
  function_name = "nextjs-on-lambda"
  architectures = [
    "arm64"
  ]
  memory_size = "256"
  package_type = "Image"
  reserved_concurrent_executions = "-1"
  image_uri = "${aws_ecr_repository.nextjs_on_lambda_ecr.repository_url}:latest"
  role = aws_iam_role.nextjs_on_lambda_role.arn
  timeout = "10"

  ephemeral_storage {
    size = "512"
  }
}

resource "aws_lambda_function_url" "nextjs_on_lambda" {
  function_name      = aws_lambda_function.nextjs_on_lambda.function_name
  authorization_type = "AWS_IAM"
  invoke_mode = "BUFFERED"
}