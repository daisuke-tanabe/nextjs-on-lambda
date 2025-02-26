terraform {
  required_version = "1.10.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }
}

provider "aws" {
  profile = var.aws_sso_profile
  region  = var.aws_region

  default_tags {
    tags = {
      Environment = "prod"
      Project     = "nextjs-on-lambda"
      ManagedBy   = "Terraform"
    }
  }
}

resource "aws_iam_role_policy" "nextjs_on_lambda_policy" {
  role = aws_iam_role.nextjs_on_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup"
        ]
        Effect   = "Allow"
        Resource = format("arn:aws:logs:%s:%s:*",
          var.aws_region,
          var.aws_sso_account_id,
        )
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = format("arn:aws:logs:%s:%s:log-group:/aws/lambda/%s:*",
          var.aws_region,
          var.aws_sso_account_id,
          aws_lambda_function.nextjs_on_lambda.function_name
        )
      }
    ]
  })
}

resource "aws_iam_role" "nextjs_on_lambda_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
