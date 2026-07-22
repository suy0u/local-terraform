resource "aws_instance" "webserver1" {
  ami           = "ami-024f768332f0"
  instance_type = var.env == "prod" ? var.ec2_size[var.env] : var.ec2_size["dev"]

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.nonprod_owner 
  }
}

resource "aws_instance" "bastion" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-024f768332f0"
  instance_type = var.env == "prod" ? "t2.large" : "t2.micro"

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.nonprod_owner 
  }
}

resource "aws_instance" "webserver2" {
  ami           = "ami-024f768332f0"
  instance_type = lookup(var.ec2_size, var.env)

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.nonprod_owner 
  }
}

resource "aws_security_group" "webserver_sg" {
  name = "Web Server Security Group"

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env) 
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
}
