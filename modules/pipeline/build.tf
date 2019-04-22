resource "aws_iam_role" "iam_code_build_role" {
  name = "iam_code_build_role"
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
  name = "iam_code_build_policy"
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



# TODO: Remove duplication between codebuild steps
# Only difference is resource name & env variable.
resource "aws_codebuild_project" "codebuild_invoke_terraform_staging" {
  name          = "codebuild_infra_staging"
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
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

}

resource "aws_codebuild_project" "codebuild_invoke_terraform_production" {
  name          = "codebuild_infra_production"
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
      value = "prod"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }

}