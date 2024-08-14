# AWS CodePipeline created using Terraform
This infrastructure is designed to create a pipeline in AWS, enabling parallelized builds for efficiency. One build is dedicated to compiling the source code and storing artifacts, while the other focuses on testing the source code. The deployment process is managed seamlessly by AWS Elastic Beanstalk.

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
