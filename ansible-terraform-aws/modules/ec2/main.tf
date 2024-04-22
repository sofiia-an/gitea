resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "aws_key" {
  key_name = "ansible-ssh-key"
  public_key = tls_private_key.key.public_key_openssh
}


resource "aws_instance" "ec2_instances" {
  ami = "ami-0b9932f4918a00c4f"
  instance_type = var.instances_type
  count = var.instance_count
  key_name = aws_key_pair.aws_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = var.security_groups
  subnet_id = var.subnets[count.index % length(var.subnets)]

   
  tags = {
    Name = element(var.instance_tags, count.index)
  }
}
