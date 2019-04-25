
module "pipeline-ui-api" {
  source = "../pipeline"
  name = "ui-api"
  aws_region = "${var.aws_region}"
  tags = "${var.tags}"
  github_org = "${var.github_org}"
  repo = "rf-ui-api"
  branch = "master"
  artefact_bucket_name = "${aws_s3_bucket.artefacts.bucket}"
  artefact_bucket_arn = "${aws_s3_bucket.artefacts.arn}"
  buildcode_target_staging = "${aws_codebuild_project.codebuild_terraform_ui-api_staging.name}"
  buildcode_target_production = "${aws_codebuild_project.codebuild_terraform_ui-api_production.name}"
}
resource "aws_codebuild_project" "codebuild_terraform_ui-api_staging" {
  name          = "rf-codebuild-ui-api-staging"
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
      name = "Environment"
      value = "staging"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

}

resource "aws_codebuild_project" "codebuild_terraform_ui-api_production" {
  name          = "rf-codebuild-ui-api-production"
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
      name = "Environment"
      value = "production"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

}