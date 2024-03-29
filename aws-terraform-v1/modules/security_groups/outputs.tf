output "sg_name" {
    description = "Security group name"
  value = aws_security_group.ec2_sg.name
}