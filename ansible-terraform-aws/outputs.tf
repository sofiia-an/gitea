output "ec2-info" {
  value       = module.ec2.ec2-data
}

output "rds-endpoint" {
  value       = module.rds.db_endpoint
}
