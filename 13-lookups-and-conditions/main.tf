resource "aws_instance" "webserver1" {
  ami           = "ami-024f768332f0"
  instance_type = var.env == "prod" ? "t2.large" : "t2.micro"

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
