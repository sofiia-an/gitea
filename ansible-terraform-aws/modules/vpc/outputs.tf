output "vpc_id" {
    value = aws_vpc.vpc.id  
}

output "public_subnets" {
    value = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
}

output "private_subnets_ec2" {
    value = [aws_subnet.private_subnet_a_ec2.id, aws_subnet.private_subnet_b_ec2.id]
}

output "private_subnets_rds" {
    value = [aws_subnet.private_subnet_a_rds.id, aws_subnet.private_subnet_b_rds.id]
}
output "efs_subnet" {
    value = aws_subnet.private_subnet_efs.id
}