
module "pipeline-app" {
  source = "../pipeline"
  name = "infra-app"
  aws_region = "${var.aws_region}"
  tags = "${var.tags}"
  github_org = "${var.github_org}"
  repo = "infra"
  branch = "master"
  artefact_bucket_name = "${aws_s3_bucket.artefacts.bucket}"
  artefact_bucket_arn = "${aws_s3_bucket.artefacts.arn}"
  buildcode_target_staging = "${aws_codebuild_project.codebuild_terraform_app_staging.name}"
  buildcode_target_production = "${aws_codebuild_project.codebuild_terraform_app_production.name}"
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