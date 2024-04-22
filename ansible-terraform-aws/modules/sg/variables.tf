variable "sg_name" {
  default = "ec2-security-group"  
}

variable "vpc_id" {
  type = string  
}

variable "allowed_ports" {
  description = "List of allowed ports"
  type        = list(any)
  default     = ["3000", "2049", "80"]
}

variable "rds_sg_name" {
  default = "rds-security-group"
}

variable "efs_sg_name"{
  default = "efs-security-group"
}

variable "lb_sg_name" {
  default = "lb-security-group"
}
