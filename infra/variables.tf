variable "app_name" {
  default = "nextjs-on-lambda"
}

#--------------------------------------------------------------
# AWS
#--------------------------------------------------------------
variable "aws_sso_profile" {}

variable "aws_sso_account_id" {}

variable "aws_region" {
  default = "ap-northeast-1"
}