output "github_oauth_token" {
  value = "${aws_ssm_parameter.github_oauth_token.name}"
}
