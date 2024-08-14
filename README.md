# AWS CodePipeline created using Terraform
This infrastructure is designed to create a pipeline in AWS, enabling parallelized builds for efficiency. One build is dedicated to compiling the source code and storing artifacts, while the other focuses on testing the source code. The deployment process is managed seamlessly by AWS Elastic Beanstalk.

**Files:**
1. [`pipeline.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/pipeline.tf) defines the AWS CodePipeline resources, specifying the stages, actions, and integrations used for the CI/CD pipeline.
2. [`codebuild.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/codebuild.tf) configures the AWS CodeBuild resources for both the build and test stages, detailing project settings and environments.
3. [`buildspec.yml`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/buildspec.yml) defines the build instructions for compiling the Node.js application and storing artifacts.
4. [`buildspec.yml`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/buildspec_test.yml) specifies the testing steps, including running the test.js script and generating coverage test and Jest test reports.
5. [`elastic_beanstalk.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/elastic_beanstalk.tf) sets up the Elastic Beanstalk environment, including the application, environment configuration, and deployment settings.
6. [`provider.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/provider.tf) specifies the Terraform provider (AWS), along with the region (us-east-1).
7. [`variables.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/variables.tf) declares variables used across the Terraform configuration files.
8. [`terraform.tfvars`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/terraform.tfvars) contains the actual values for the variables defined in [`variables.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/variables.tf).

## Installation
- Terraform command to initialize the project
```
terraform init
```
* Terraform command to plan the changes and to check again the resources that were added, changed or deleted
```
terraform plan -out plan.out
```
- Terraform command to apply the changes
```
terraform apply plan.out --auto-approve
```
