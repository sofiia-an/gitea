variable "allocated_storage" {
    description = "Allocated storage size RDS"
    type = number
    default = 15
}

variable "engine" {
    description = "Database Engine"
    type = string
    default = "mysql"
}

variable "engine_version" {
    description = "Database engine version"
    type = string
    default = "8.0"
}

variable "instance_class" {
    description = "Database instance class/type"
    type = string
    default = "db.t3.micro"  
}

variable "identifier" {
    description = "Name of the RDS instance"
    type = string
    default = "mysql-db"
}

variable "username" {
    description = "Database username"
    type = string
     
}

variable "password" {
    description = "Database password"
    type = string
    
}

variable "db_name" {
    description = "Database name"
    type = string
    
}

variable "skip_final_snapshot" {
    description = "Skip final Snapshot"
    type = bool
    default = true #This is good when you are working in development environment, adjust as per your need.
}

variable "subnets" {
    type = list(string)  
}

variable "security_groups" {
    type = list(string)
}
