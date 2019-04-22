resource "aws_s3_bucket" "artefacts" {
  bucket = "recipe-finder-artefact-bucket"
  acl    = "private"
  tags = "${var.tags}"
}

resource "aws_iam_role" "role" {
  name = "recipe-finder-role"
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
  name = "recipe-finder-codepipeline_policy"
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
  name     = "recipe-finder-terraform-pipeline"
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
      output_artifacts = ["terraform_project"]

      configuration = {
        Owner                = "${var.github_org}"
        Repo                 = "${var.repo}"
        PollForSourceChanges = "true"
        Branch               = "${var.branch}"
        OAuthToken           = "${var.github_oauth_token}"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Terraform-Apply-Staging"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["terraform_project"]
      version         = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild_invoke_terraform_staging.name}"
      }
    }
  }

  stage {
    name = "Terraform-Production-Aproval"

    action {
      name = "Approve"
      category = "Approval"
      owner = "AWS"
      provider = "Manual"
      version = "1"
    }
  }

  stage {
    name = "Terraform-Apply-Production"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["terraform_project"]
      version         = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild_invoke_terraform_production.name}"
      }
    }
  }
}