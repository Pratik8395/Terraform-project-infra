# provider version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Region, Key, Secretkey
provider "aws" {
  region     = var.region
  access_key = var.accKey
  secret_key = var.secKey
}


# creating test vpc
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "test_vpc"
  }
}


# Creating dev_subnet
resource "aws_subnet" "test_vpc_dev_subnet" {
  vpc_id     = "${aws_vpc.test_vpc.id}"
  cidr_block = "10.20.1.0/24"

  availability_zone = "eu-north-1a"

  tags = {
    Name = "test_vpc_dev_subnet"
  }
}



# Creating qa_subnet
resource "aws_subnet" "test_vpc_qa_subnet" {
  vpc_id     = "${aws_vpc.test_vpc.id}"
  cidr_block = "10.20.2.0/24"

  availability_zone = "eu-north-1b"

  tags = {
    Name = "test_vpc_qa_subnet"
  }
}


# Creating uat_subnet
resource "aws_subnet" "test_vpc_uat_subnet" {
  vpc_id     = "${aws_vpc.test_vpc.id}"
  cidr_block = "10.20.3.0/24"

  availability_zone = "eu-north-1c"

  tags = {
    Name = "test_vpc_uat_subnet"
  }
}



# Create internet gateway
resource "aws_internet_gateway" "test_vpc_gw" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  tags = {
    Name = "test_vpc_gw"
  }
}



# Creating route table
resource "aws_route_table" "test_vpc_rt" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test_vpc_gw.id}"
  }

  tags = {
    Name = "test_vpc_rt"
  }
}


# Route Table Association qa
resource "aws_route_table_association" "rt_qa" {
  subnet_id      = "${aws_subnet.test_vpc_qa_subnet.id}"
  route_table_id = "${aws_route_table.test_vpc_rt.id}"
}


# Route Table Association uat
resource "aws_route_table_association" "rt_uat" {
  subnet_id      = "${aws_subnet.test_vpc_uat_subnet.id}"
  route_table_id = "${aws_route_table.test_vpc_rt.id}"
}



# Route Table Association dev
resource "aws_route_table_association" "rt_dev" {
  subnet_id      = "${aws_subnet.test_vpc_dev_subnet.id}"
  route_table_id = "${aws_route_table.test_vpc_rt.id}"
}


# Creating Test_vpc_sg 
resource "aws_security_group" "test_vpc_sg" {
  name        = "test_vpc_sg"
  description = "test_vpc_sg"
  vpc_id      = "${aws_vpc.test_vpc.id}"

  ingress {
    description      = "test_vpc_sg"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 
  }

  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "test_vpc_sg"
  }
}




# instance for dev
resource "aws_instance" "dev_test_1" {

  ami                     = "ami-09ed8fb06b42a771d"
  instance_type           = "t3.micro"
  associate_public_ip_address= "true"
  key_name= "linux-vm-key"
  vpc_security_group_ids= [aws_security_group.test_vpc_sg.id]
  subnet_id = "${aws_subnet.test_vpc_dev_subnet.id}"
  
}



# instance for qa
resource "aws_instance" "qa_test_1" {
  ami                     = "ami-09ed8fb06b42a771d"
  instance_type           = "t3.micro"
  associate_public_ip_address= "true"
  key_name= "linux-vm-key"
  vpc_security_group_ids= [aws_security_group.test_vpc_sg.id]
  subnet_id = "${aws_subnet.test_vpc_qa_subnet.id}"

}



# instance for uat
resource "aws_instance" "uat_test_1" {
  ami                     = "ami-09ed8fb06b42a771d"
  instance_type           = "t3.micro"
  associate_public_ip_address= "true"
  key_name= "linux-vm-key"
  vpc_security_group_ids= [aws_security_group.test_vpc_sg.id]
  subnet_id = "${aws_subnet.test_vpc_uat_subnet.id}"

}


# vpc peering
# vpc peering

resource "aws_vpc" "devops-vpc" {
  cidr_block = "10.10.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  # Other attributes...
}


resource "aws_vpc_peering_connection" "dev_to_test" {
  peer_vpc_id   = "vpc-0280962680ef8adce"
  vpc_id        = "${aws_vpc.test_vpc.id}"

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  auto_accept = true

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

















