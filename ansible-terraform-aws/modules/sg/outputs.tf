output "ec2_sg_id" {
  description = "EC2 security group ID"
  value = aws_security_group.ec2_sg.id
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value = aws_security_group.rds_sg.id
}

output "lb_sg_id" {
  description = "LB security group ID"
  value = aws_security_group.lb_sg.id
}

output "efs_sg_id" {
  description = "EFS security group ID"
  value = aws_security_group.efs_ingress.id
}

output "allow_ssh_id" {
  description = "Allow ssh for Ansible"
  value = aws_security_group.allow_ssh.id
}

