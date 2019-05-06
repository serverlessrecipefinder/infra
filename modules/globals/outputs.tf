resource "aws_ssm_parameter" "cognito_user_pool_arn" {
  type  = "String"
  description = "ARN of global Cognito User Pool"
  name  = "/${var.prefix}/globals/cognito_user_pool_arn"
  value = "${aws_cognito_user_pool.pool.arn}"
  overwrite = true
}
