resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.application}-vpc"
    }  
}

resource "aws_internet_gateway" "vpc_igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.application}-igw"
    }
}

resource "aws_subnet" "public_subnet_a" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "eu-west-2a"
    
    tags = {
      Name = "${var.application}-public-subnet-a"
    }
}

resource "aws_subnet" "public_subnet_b" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "eu-west-2b"
    
    tags = {
      Name = "${var.application}-public-subnet-b"
    }
}

resource "aws_subnet" "private_subnet_a_ec2" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = "10.0.3.0/24"
    availability_zone = "eu-west-2a"
    map_public_ip_on_launch = false
    
    tags = {
      Name = "${var.application}-private-subnet-a-ec2"
    }
}

resource "aws_subnet" "private_subnet_b_ec2" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = "10.0.4.0/24"
    availability_zone = "eu-west-2b"
    map_public_ip_on_launch = false
    
    tags = {
      Name = "${var.application}-private-subnet-b-ec2"
    }
}

resource "aws_subnet" "private_subnet_a_rds" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = "10.0.5.0/24"
    availability_zone = "eu-west-2a"
    
    tags = {
      Name = "${var.application}-private-subnet-a-rds"
    }
}

resource "aws_subnet" "private_subnet_b_rds" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = "10.0.6.0/24"
    availability_zone = "eu-west-2b"
    
    tags = {
      Name = "${var.application}-private-subnet-b-rds"
    }
}

resource "aws_subnet" "private_subnet_efs" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = "10.0.7.0/24"
    availability_zone = "eu-west-2c"
    
    tags = {
      Name = "${var.application}-private-subnet-efs"
    }
}


resource "aws_route_table" "vpc_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.vpc_igw.id
    }

    tags = {
      Name = "${var.application}-rt"
    }
}

resource "aws_route_table_association" "vpc_rt_association" {
    count = 2
    subnet_id = element([aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id], count.index)
    route_table_id = aws_route_table.vpc_rt.id

}

