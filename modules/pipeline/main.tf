resource "aws_s3_bucket" "artefacts" {
  bucket = "${var.prefix}-artefacts"
  acl    = "private"
  tags = "${var.tags}"
}

resource "aws_iam_role" "role" {
  name = "${var.prefix}-role"
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

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.prefix}-codepipeline_policy"
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

resource "aws_codepipeline" "terraform" {
  name     = "${var.prefix}-terraform-pipeline"
  role_arn = "${aws_iam_role.role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artefacts.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["test"]

      configuration = {
        Owner                = "${var.github_org}"
        Repo                 = "${var.repo}"
        PollForSourceChanges = "true"
        Branch               = "${var.branch}"
        OAuthToken           = "${var.github_oauth_token}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["test"]
      version         = "1"

      configuration = {
        ProjectName = "test"
      }
    }
  }
}