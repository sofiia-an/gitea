variable "instances_type" {
    default = "t2.micro"
}

variable "instance_count" {
    default = "2"
  
}

variable "instance_tags" {
    type = list(string)
    default = ["tf-ansible-1", "tf-ansible-2"]
}

variable "security_groups" {
    type = list(string)
}

variable "subnets" {
    type = list(string)
}
