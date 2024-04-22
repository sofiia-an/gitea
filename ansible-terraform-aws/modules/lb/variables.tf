variable "application"{
    type = string
}

variable "lb_sg" {
    type = string  
}

variable "subnets" {
    type = list(string)
}

variable "target_group_name" {
    type = string
}

variable "target_port" {
    type = number 
}

variable "vpc_id" {
    type = string
}

variable "listener_port" {
    type = number
}

variable "instances" {
    type = list(object({
      id = string
   }))
}
