resource "aws_iam_role" "iam_code_build_role" {
  name = "rf-codebuild-role-infra"
  permissions_boundary = ""
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "iam_code_build_policy" {
  name = "rf-codebuild-policy-infra"
  role = "${aws_iam_role.iam_code_build_role.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
          "*"
      ],
      "Resource": "*",
      "Effect": "Allow",
      "Sid": "ManageInfrastructure"
    }
  ]
}
POLICY
}
