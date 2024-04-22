output "ec2-data" {
  value       = [for vm in aws_instance.ec2_instances[*] : {
    ip_address  = vm.public_ip
    public_dns = vm.public_dns
  }]
  description = "The public IP and DNS of the servers"
}        


output "ec2_instance" {
  value = aws_instance.ec2_instances
}
