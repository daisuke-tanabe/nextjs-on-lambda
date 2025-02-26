resource "aws_ecr_repository" "nextjs_on_lambda_ecr" {
  name = "nextjs-on-lambda"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
  
  image_scanning_configuration {
    scan_on_push = true
  }
}