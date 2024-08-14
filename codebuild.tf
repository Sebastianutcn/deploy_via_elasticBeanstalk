data "aws_caller_identity" "current" {}

# S3 bucket used to store both build output and test output
resource "aws_s3_bucket" "ebapp" {
  bucket = "codebuild-ebapp"
}

# S3 bucket properties 
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.ebapp.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.ebapp]
}

resource "aws_s3_bucket_ownership_controls" "ebapp" {
  bucket = aws_s3_bucket.ebapp.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

# Enabling versioning
resource "aws_s3_bucket_versioning" "ebapp" {
  bucket = aws_s3_bucket.ebapp.id
  versioning_configuration {
    status = "Enabled"
  }
}

# CodeBuild role
resource "aws_iam_role" "codebuild-role" {
  name = "codebuild-role-ebapp"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# CodeBuild role policy
resource "aws_iam_role_policy" "codebuild-policy" {
  role = aws_iam_role.codebuild-role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.ebapp.arn}",
        "${aws_s3_bucket.ebapp.arn}/*"
      ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:UpdateReport",
            "codebuild:BatchPutCodeCoverages"
        ],
        "Resource": "arn:aws:codebuild:us-east-1:381492073646:report-group/*"
    },
    {
      "Action" : [
        "ssm:GetParameters"
      ],
      "Resource" : "*",
      "Effect" : "Allow"
    }
  ]
}
POLICY
}

# CodeBuild project used for compiling and storing artifacts
resource "aws_codebuild_project" "ebapp" {
  name          = "ebapp"
  description   = "A node.js app build project for ElasticBeanstalk"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.ebapp.bucket
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.ebapp.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
      type  = "PLAINTEXT"
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.ebapp.id}/build-log"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/eb-demo-repo"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  tags = {
    Environment = "Build"
  }
}

# CodeBuild project used for testing
resource "aws_codebuild_project" "ebapp_test" {
  name          = "ebapp_test"
  description   = "A node.js app build project for testing"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.ebapp.bucket
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.ebapp.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
      type  = "PLAINTEXT"
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.ebapp.id}/build-log"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/eb-demo-repo"
    git_clone_depth = 1
    buildspec       = file("buildspec_test.yml")

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  tags = {
    Environment = "Test"
  }
}