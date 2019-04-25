resource "aws_codepipeline" "terraform_app" {
  name     = "rf-codepipeline-app"
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
        OAuthToken           = "${data.aws_ssm_parameter.github_oauth_token.value}"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Apply-Staging"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["terraform_project"]
      version         = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild_terraform_app_staging.name}"
      }
    }
  }

  stage {
    name = "Production-Aproval"

    action {
      name = "Approve"
      category = "Approval"
      owner = "AWS"
      provider = "Manual"
      version = "1"
    }
  }

  stage {
    name = "Apply-Production"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["terraform_project"]
      version         = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild_terraform_app_production.name}"
      }
    }
  }
}

resource "aws_codebuild_project" "codebuild_terraform_app_staging" {
  name          = "rf-codebuild-app-staging"
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
      value = "staging"
    }

    environment_variable {
      name = "TfTargetDir"
      value = "app"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

}

resource "aws_codebuild_project" "codebuild_terraform_app_production" {
  name          = "rf-codebuild-app-production"
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
      value = "production"
    }

    environment_variable {
      name = "TfTargetDir"
      value = "app"
    }

  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

}