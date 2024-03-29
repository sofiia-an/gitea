variable "ec2_instance_type" {
    default = "t3.micro"
}

variable "instance_profile" {
    default = "aws-elasticbeanstalk-ec2-role"
  
}
variable "db_engine" {
    default = "mysql"
}

variable "db_engine_version" {
    default = "8.0"
}

variable "db_instance_type" {
    default = "db.t3.micro"
}

variable "db_allocated_storage" {
    description = "Allocated storage for RDS instance in GB"
    default = 10
}

variable "db_name" {
    type = string
    default = "gitea_db"  
}

variable "db_username" {
    type = string
    default = "giteaadmin"  
}

variable "db_password" {
    type = string
    default = "giteaadmin"  
}

variable "bucket_name" {
    type = string 
}

variable "bucket_key" {
    type = string  
}

variable "security_groups" {
  type = string
}