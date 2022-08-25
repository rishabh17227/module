terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  count                       = length(var.ec2_name)
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  security_groups             = [aws_security_group.security_group.id]
  associate_public_ip_address = var.associate_public_ip_address
  tags = {
    Name = var.ec2_name[count.index]
  }
}

resource "aws_security_group" "security_group" {
  name = var.sg_name
  tags = {
    name = var.sg_name
  }
  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = var.ingress_cidr
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = var.egress_cidr
    }
  }
}