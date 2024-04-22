resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = var.subnets
  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage      = var.allocated_storage
  backup_retention_period = 7
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  identifier             = var.identifier
  username               = var.username
  password               = var.password
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = var.security_groups
  skip_final_snapshot    = var.skip_final_snapshot

  tags = {
    Name = "Mysql-RDS"
  }
}
