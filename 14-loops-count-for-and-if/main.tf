resource "aws_iam_user" "user1" {
  name = "Max"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

#-------------------------------------------------

resource "aws_instance" "servers" {
  count = 3
  ami   = "ami-024f768332f0"
  instance_type = "t3.micro"

  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}

#--------------------------------------------------

