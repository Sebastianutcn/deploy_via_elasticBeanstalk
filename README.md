# AWS CodePipeline created using Terraform
This infrastructure is designed to create a pipeline in AWS, enabling parallelized builds for efficiency. One build is dedicated to compiling the source code and storing artifacts, while the other focuses on testing the source code. The deployment process is managed seamlessly by AWS Elastic Beanstalk.

**Files:**
1. [`pipeline.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/pipeline.tf) is used to create the pipeline and IAM roles for it. All the stages are put together.
2. [`codebuild.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/codebuild.tf) is used to provision the build stage and the IAM roles for it. The source is AWS CodeCommit.
3. [`buildspec.yml`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/buildspec.yml) is a script used to install the agent for CodeDeploy on EC2 instance.
4. [`buildspec.yml`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/buildspec_test.yml) is a script used to install the agent for CodeDeploy on EC2 instance.
5. [`elastic_beanstalk.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/elastic_beanstalk.tf) is used to provision the deploy stage and the IAM roles for it. The deployment is done by an EC2 instance.
6. [`provider.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/provider.tf) is a script used to install the agent for CodeDeploy on EC2 instance.
7. [`variables.tf`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/variables.tf) is a script used to install the agent for CodeDeploy on EC2 instance.
8. [`terraform.tfvars`](https://github.com/Sebastianutcn/deploy_via_elasticBeanstalk/blob/main/terraform.tfvars) is a script used to install the agent for CodeDeploy on EC2 instance.

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
