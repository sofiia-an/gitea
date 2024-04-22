 resource "local_sensitive_file" "private_key" {
   content = tls_private_key.key.private_key_pem
   filename          = format("%s/%s/%s", abspath(path.root), "ansible/.ssh", "ansible-ssh-key.pem")
   file_permission   = "0600"
 }

 resource "local_file" "ansible_inventory" {
   content = templatefile("modules/ec2/inventory.tftpl", {
     ip_addrs = [for i in aws_instance.ec2_instances:i.public_ip]
     ssh_keyfile = local_sensitive_file.private_key.filename
   })
   filename = format("%s/%s", abspath(path.root), "inventory.ini")
 }        
