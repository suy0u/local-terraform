data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  az_list            = join(",", data.aws_availability_zones.available.names)
  region_description = data.aws_region.current.description
  location           = "In ${local.region_description} there are AZ: ${local.az_list}" 
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
   name   = "name"
   values = ["al2023-ami-2023.*-x86_64"]
  }
}

#-----------------------------------------------------------
resource "aws_eip" "static_ip" {
  instance = aws_instance.server.id
  tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Server IP", Location = local.location})
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.server.id]
  monitoring             = var.enable_detailed_monitoring

  tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Server Build by Terraform"})
}

resource "aws_security_group" "server" {

  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Dynamic Security Group"})
}

