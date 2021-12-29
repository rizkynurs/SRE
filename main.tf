# Provider yang digunakan adalah AWS
# Versi dikunci pada 3.22.x
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

#1 VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  
  enable_dns_hostnames = true
  tags = {
    Name = "example"
  }
}

data "aws_availability_zones" "available" {}

#1 subnet public
resource "aws_subnet" "public" {
  depends_on = [
    aws_vpc.example
  ]
  
  # VPC in which subnet has to be created!
  vpc_id = aws_vpc.example.id
  
  # IP Range of this subnet
  cidr_block = "10.0.2.0/24"
  
  # Data Center of this subnet.
  availability_zone = "ap-southeast-1"
  
  # Enabling automatic public IP assignment on instance launch!
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

#1 subnet private yg terhubung dengan 1 NAT Gateway 
resource "aws_subnet" "instance" {
  depends_on = [
    aws_vpc.example,
    aws_subnet.public
  ]
  
  # VPC in which subnet has to be created!
  vpc_id = aws_vpc.example.id
  
  # IP Range of this subnet
  cidr_block = "10.0.1.0/24"
  
  # Data Center of this subnet.
  availability_zone = "ap-southeast-1"
  
  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  connectivity_type = "private"
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.instance.id
  tags = {
    "Name" = "DummyNAT"
  }
}

data "aws_ami" "demo_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_template" "template" {
  ami = data.aws_ami.demo_ami.id
  instance_type = "t2.medium"
  subnet_id = aws_subnet.instance.id
  vpc_zone_identifier = var.asg_vpc_zone_identifier
  tags = var.default_tags
  volume_tags = var.default_tags
}

resource "aws_autoscaling_group" "group" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 5
  min_size           = 2
  
  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "example" {
  name = "test-auto_policy"
  autoscaling_group_name = aws_autoscaling_group.group.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 45.0
  }
}