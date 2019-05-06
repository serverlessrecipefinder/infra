resource "aws_ssm_parameter" "cognito_user_pool_arn" {
  type  = "String"
  description = "ARN of global Cognito User Pool"
  name  = "/${var.prefix}/globals/cognito_user_pool_arn"
  value = "${aws_cognito_user_pool.pool.arn}"
  overwrite = true
}

resource "aws_ssm_parameter" "certificate_arn" {
  type  = "String"
  description = "ARN of wildcard certificate for recipefinder.io"
  name  = "/${var.prefix}/globals/certificate_arn"
  value = "${aws_acm_certificate.cert.arn}"
  overwrite = true
}

