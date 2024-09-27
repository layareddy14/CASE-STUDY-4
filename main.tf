provider "aws" {
  region = "us-west-1"  # Change to your desired region
}

# VPC Creation
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyVPC"
  }
}
# Subnets in Different Availability Zones
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1a"

  tags = {
    Name = "SubnetA"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-1b"

  tags = {
    Name = "SubnetB"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-1c"

  tags = {
    Name = "SubnetC"
  }
}
# Security Group for EC2 Instances
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change for more secure access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2SecurityGroup"
  }
}
resource "aws_s3_bucket" "shared_storage" {
  bucket = "jaya6789"
  
  # Other bucket configuration options
}

resource "aws_s3_bucket_versioning" "shared_storage_versioning" {
  bucket = aws_s3_bucket.shared_storage.id

  # This block is necessary and should not be empty
  versioning_configuration {
    status = "Enabled"  # Set the status to "Enabled" or "Suspended"
  }
}


# IAM Role for EC2 to Access S3
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Effect    = "Allow"
      Sid       = ""
    }]
  })
}

# IAM Policy for S3 Access
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy for EC2 instances to access S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "s3:*"
      Resource = "${aws_s3_bucket.shared_storage.arn}/*"
      Effect   = "Allow"
    }]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}



resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "ec2_s3_role"  # This should match what you reference in the EC2 instance
  role = aws_iam_role.ec2_s3_role.name
}

# EC2 Instances
resource "aws_instance" "ec2_instance_a" {
  ami           = "ami-0d53d72369335a9d6"  # Update with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_a.id
  security_groups = [aws_security_group.ec2_sg.id]
  iam_instance_profile = aws_iam_role.ec2_s3_role.name

  user_data = <<-EOF
              #!/bin/bash
              yum install -y amazon-linux-extras
              amazon-linux-extras install docker
              service docker start
              EOF

  tags = {
    Name = "EC2InstanceA"
  }
}

resource "aws_instance" "ec2_instance_b" {
  ami           = "ami-0d53d72369335a9d6"  # Update with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_b.id
  security_groups = [aws_security_group.ec2_sg.id]
  iam_instance_profile = aws_iam_role.ec2_s3_role.name

  user_data = <<-EOF
              #!/bin/bash
              yum install -y amazon-linux-extras
              amazon-linux-extras install docker
              service docker start
              EOF

  tags = {
    Name = "EC2InstanceB"
  }
}

resource "aws_instance" "ec2_instance_c" {
  ami           = "ami-0d53d72369335a9d6"  # Update with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_c.id
  security_groups = [aws_security_group.ec2_sg.id]
  iam_instance_profile = aws_iam_role.ec2_s3_role.name

  user_data = <<-EOF
              #!/bin/bash
              yum install -y amazon-linux-extras
              amazon-linux-extras install docker
              service docker start
              EOF

  tags = {
    Name = "EC2InstanceC"
  }
}

