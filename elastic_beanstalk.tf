# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "elasticapp" {
  name        = var.elasticapp
  description = "My Elastic Beanstalk application"
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {
  name                = var.beanstalkappenv
  application         = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name = var.solution_stack_name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  # setting {
  #   namespace = "aws:autoscaling:asg"
  #   name      = "MinSize"
  #   value     = 1
  # }
  # setting {
  #   namespace = "aws:autoscaling:asg"
  #   name      = "MaxSize"
  #   value     = 2
  # }

  # setting {
  #   namespace = "aws:elasticbeanstalk:environment"
  #   name      = "EnvironmentType"
  #   value     = "LoadBalanced"
  # }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  "ec2_profile"
  }
}

#IAM roles and policies
resource "aws_iam_role" "elastic_beanstalk_service_role" {
  name = "elastic_beanstalk_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "elasticbeanstalk.amazonaws.com"
      }
    }]
  })
}

# IAM policy for Elastic Beanstalk service
resource "aws_iam_role_policy_attachment" "elastic_beanstalk_service_policy" {
  role       = aws_iam_role.elastic_beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# IAM instance profile for Elastic Beanstalk
resource "aws_iam_instance_profile" "elastic_beanstalk_instance_profile" {
  name = "elastic_beanstalk_instance_profile"
  role = aws_iam_role.elastic_beanstalk_service_role.name
}


