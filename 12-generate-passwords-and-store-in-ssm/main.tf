resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#$&"
  keepers = {
    keeper1 = var.key
  }
}

resource "aws_ssm_parameter" "rds_password" {
  name         = "/prod/mysql"
  description = "Master Password for RDS MySQL"
  type         = "SecureString"
  value        = random_string.rds_password.result
}

data "aws_ssm_parameter" "my_rds_password" {
  name = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

resource "aws_db_parameter_group" "default" {
  name   = "prod-rds-pg"
  family = "mysql8.0"
}

resource "aws_db_instance" "default" {
  identifier           = "prod-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  db_name                 = "test"
  username             = "terraform"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = aws_db_parameter_group.default.name
  skip_final_snapshot  = true
  apply_immediately    = true
}
