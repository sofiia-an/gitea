resource "aws_efs_file_system" "my_efs" {
  creation_token = "my-efs"

  tags = {
    Name = "Gitea-EFS"
  }
}

resource "aws_efs_mount_target" "my_mount_target" {
  file_system_id  = aws_efs_file_system.my_efs.id
  subnet_id = var.subnet_id
  security_groups = var.security_group_ids
}
