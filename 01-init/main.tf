resource "aws_instance" "ubuntu" {
  count         = 2
  ami           = "ami-df5de72bdb3b"
  instance_type = "t3.micro"
  tags          = {

    Name  = "My Ubuntu Server"
    Owner = "suy0u"
    Projekt = "tflocal"

  }


}

resource "aws_instance" "amazon_linux" {
  ami           = "ami-024f768332f0"
  instance_type = "t3.micro"
  tags          = {

    Name  = "My Amazon Server"
    Owner = "suy0u"
    Projekt = "tflocal"

  }

}
