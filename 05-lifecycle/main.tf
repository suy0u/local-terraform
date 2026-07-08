#------------------------------------------------------
# tflocal
# Build Web Server
#------------------------------------------------------

resource "aws_instance" "web_server" {
  ami                    = "ami-024f768332f0"  
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]  
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Mustermann",
    l_name = "Muster",
    names  = ["Max", "Nico", "Peter", "Alice", "Megan", "Lukas"]
  })
  
  user_data_replace_on_change = true

  tags = {
    Name  = "lifecycle and zero downtime"
    Owner = "suy0u"
  }
  
  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_security_group" "webserver_sg" {
  name        = "Web Server Security Group"
  description = "test Security Group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
