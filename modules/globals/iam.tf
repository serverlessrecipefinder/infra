resource "aws_iam_role" "role" {
  name = "rf-codepipeline-role-globals"
  tags = "${var.tags}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

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

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "rf-codepipeline-policy-globals"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.artefacts.arn}",
        "${aws_s3_bucket.artefacts.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}