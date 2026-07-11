#----------------------------------------------------------
# Provision Highly Availabe Web in any Region Default VPC
# Create:
#        - Security Group for Web Server
#        - Launch Configuration with Auto AMI Lookup
#        - Auto Scaling Group using 2 Availability Zones
#        - Classic Load Balancer in 2 Availability Zones
#
#-----------------------------------------------------------

data "aws_availability_zones" "available" {}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
   name   = "name"
   values = ["al2023-ami-2023.*-x86_64"]
  }
}

#-----------------------------------------------------------
resource "aws_security_group" "web" {
  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = ["80", "443"]
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
  
  tags = {
    Name  = "Dynamic Security Group"
    Owner = "suy0u"
  }

}

resource "aws_launch_template" "web" {
  name_prefix     = "web-lt-"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web.id]
  user_data       = base64encode(file("user_data.sh"))

  lifecycle {
    create_before_destroy = true
  }
}


#------------------------------------------------------------
resource "aws_autoscaling_group" "web" {
  name                  = "web-asg-${aws_launch_template.web.latest_version}"
  min_size              = 2
  max_size              = 2
  vpc_zone_identifier   = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  health_check_type     = "ELB"
  target_group_arns     = [aws_lb_target_group.web.arn]
  wait_for_elb_capacity = 2

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version 
  }

  dynamic "tag" {
    for_each = {
      Name  = "Web_Server_in_ASG"
      Owner = "suy0u"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  
  lifecycle {
    create_before_destroy = true
  }

}

#-------------------------------------------------------------
resource "aws_lb" "web" {
  name               = "Web-Server-HA-ALB"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
}

resource "aws_lb_target_group" "web" {
  name     = "Web-Server-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_subnet.default_az1.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 10
  }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
#---------------------------------------------------------------
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}
