provider "aws" {
  region = "us-east-1" # Set your desired AWS region here
}

resource "aws_instance" "terraform_instance_test" {
  ami           =  "ami-079db87dc4c10ac91" 
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


/*
resource "aws_s3_bucket" "example_bucket" {
  bucket = "gabriel_terraform_tutorial_20230905"
  acl    = "public-read" # This sets public access to the bucket

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.example_bucket_logs.id
    target_prefix = "logs/"
  }

  tags = {
    Name = "Gabriel's Tutorial Bucket"
  }
}

resource "aws_s3_bucket" "example_bucket_logs" {
  bucket = "${aws_s3_bucket.example_bucket.id}-logs"
  acl    = "log-delivery-write"

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}

resource "aws_cloudtrail" "example_cloudtrail" {
  name                          = "example-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.example_bucket.id
  include_global_service_events = true
}

*/