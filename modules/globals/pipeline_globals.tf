resource "aws_iam_role" "codepipeline_role" {
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
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "rf-codepipeline-policy-globals"
  role = "${aws_iam_role.codepipeline_role.id}"

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
resource "aws_codepipeline" "terraform_globals" {
  name     = "rf-codepipeline-globals"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

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
        OAuthToken           = "${data.aws_ssm_parameter.github_oauth_token.value}"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Terraform-Apply"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["terraform_project"]
      version         = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild_terraform_globals.name}"
      }
    }
  }
}

resource "aws_codebuild_project" "codebuild_terraform_globals" {
  name          = "rf-codebuild-globals"
  description   = "Apply terraform for environment module"
  build_timeout = "300"
  service_role  = "${aws_iam_role.iam_code_build_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:1.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name = "TerraformVersion"
      value = "0.11.13"
    }

    environment_variable {
      name = "TerraformSha256"
      value = "5925cd4d81e7d8f42a0054df2aafd66e2ab7408dbed2bd748f0022cfe592f8d2"
    }

    environment_variable {
      name = "TerragruntVersion"
      value = "v0.18.3"
    }

    environment_variable {
      name = "TerragruntSha256"
      value = "c6693de640f1195788cfed15d524f5347e869967b56a58a7689c7e29b1264883"
    }

    environment_variable {
      name = "Environment"
      value = "default"
    }

    environment_variable {
      name = "TfTargetDir"
      value = "globals"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

}
