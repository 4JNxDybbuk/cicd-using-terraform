terraform {
  backend "s3" {
    bucket = "terraform-cicd-githubactions"
    region = "us-east-1"
    key = "node/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "sg" {
  name = "sg"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "node-sg"
  }
}

resource "aws_instance" "nodeapp" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.micro"
  key_name               = "node-cicd"
  vpc_security_group_ids = [aws_security_group.sg.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key
    host        = self.public_ip
  }

  tags = {
    Name = "nodeapp"
  }
}

output "public_ip" {
  value = aws_instance.nodeapp.public_ip
}