resource "aws_security_group" "ec2_sg" {
  name        =  var.sg_name
  description = "Security group for EC2 instance"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "lb_sg" {
  name = var.lb_sg_name
  description = "Security group for LB"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "rds_sg" {
  name = var.rds_sg_name
  description = "Security group for RDS"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "lb_sg_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.lb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_sg_egress" {
  type              = "egress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  security_group_id = aws_security_group.lb_sg.id
  source_security_group_id = aws_security_group.ec2_sg.id
}


resource "aws_security_group_rule" "ec2_lb_ingress" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "ec2_lb_egress" {
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "ec2_rds_egress" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "rds_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "rds_egress" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.ec2_sg.id
}


resource "aws_security_group" "efs_ingress" {
  name = var.efs_sg_name
  description = "Security group for EFS"
  vpc_id = var.vpc_id

   ingress {
    from_port         = 2049
    to_port           = 2049
    protocol          = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
   }
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow SSH traffic"
  vpc_id = var.vpc_id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

