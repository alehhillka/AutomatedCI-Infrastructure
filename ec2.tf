provider "aws" {
  region = "eu-central-1" 
}

resource "aws_instance" "example" {
  count = 1
  ami           = "ami-063fdd0da121af774" 
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id, aws_security_group.project.id]
  subnet_id = module.vpc.public_subnets[0]
  key_name      = "ssh" 
  user_data     = base64encode(file("userdata.sh"))
   associate_public_ip_address = true
    iam_instance_profile = aws_iam_instance_profile.project_profile.name
    
  tags = {
    "Name" = "project_1"
  }
 
}

   resource "aws_ecr_repository" "nodejs" {
  name = "nodejs"
}

output "host_id" {
  value = aws_instance.example[0].host_id
}

output "instance_ids" {
  value = flatten(aws_instance.example)[*].id
}
