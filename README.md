# AutomatedCI-Infrastructure
In my GitHub project, I have implemented a comprehensive infrastructure for building, deploying, and automating workflows.

Part 1:

Set up the network infrastructure in AWS, including Virtual Private Cloud (VPC), a single public Subnet, and the necessary Security Groups.
Utilized AWS Console and Terraform for automation.
Deployed the CI tool Jenkins on an EC2 instance in the public Subnet.
Part 2:

Created an Ansible role for installing the ClamAV antivirus agent on all EC2 instances in the AWS account.
Configured a Jenkins pipeline for automated execution of this role.
Part 3:

Implemented a Jenkins pipeline for building a Docker image for the backend, based on Node.js, from a GitHub repository, and pushing this image to the Amazon Elastic Container Registry (ECR).
Enabled parameterization of the pipeline to select a branch or tag from the Git repository.
Set up Terraform for creating ECR and included code from Part 1.
Part 4:

Created a Cloudfront distribution and two S3 Buckets (for dev and prod modes) using Terraform.
Added them as Origins for Cloudfront with URL path separation.
Developed a parameterized Jenkins pipeline for uploading files from the Git repository to the selected S3 Bucket (dev or prod) and performing cache invalidation.
This project showcases my skills in working with AWS, Terraform, Jenkins, Docker, Ansible, and other tools for automating infrastructure and application deployment workflows.
