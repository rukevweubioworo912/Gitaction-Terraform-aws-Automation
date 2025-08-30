variable "region" {
    default = "us-east-1"
}
variable "instance_type" {
    default = "t2.micro"
}


variable "vpc_cidr_block" {
    default = "10.0.0.0/16"  # Replace with your VPC ID
}

variable "public_subnet_cidr_block_a" {
    default = "10.0.1.0/24"
}

variable "public_subnet_cidr_block_b" {
    default = "10.0.2.0/24"  
}