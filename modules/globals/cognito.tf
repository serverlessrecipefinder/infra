resource "aws_cognito_user_pool" "pool" {
  name = "rf-pool"
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "recipefinder"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
}

resource "aws_cognito_user_pool_client" "web-client" {
  name = "web-client"

  user_pool_id = "${aws_cognito_user_pool.pool.id}"
  supported_identity_providers = ["COGNITO"]
  allowed_oauth_flows = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  callback_urls = [
      "http://localhost:8080/login"
  ]
  default_redirect_uri = "http://localhost:8080/login"
  logout_urls = [
      "http://localhost:8080/logout"
  ]
  generate_secret = true
}
