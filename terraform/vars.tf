# variables

variable "aws_access_key" {
     default ="AWS access key"
}

variable "aws_secret_key" {
     default = "AWS secret key"
}

variable "aws_region" {
     default = "eu-west-2"
}

variable "availability_zone" {
     default = "eu-west-2a"
}

variable "vpc_CIDR_block" {
    default = "10.0.0.0/16"
}

variable "subnet_CIDR_block" {
    default = "10.0.1.0/24"
}

variable "destination_CIDR_block" {
    default = "0.0.0.0/0"
}

variable "ingress_CIDR_block" {
    type = list
    default = [ "0.0.0.0/0" ]
}

variable "egress_CIDR_block" {
    type = list
    default = [ "0.0.0.0/0" ]
}

variable "map_PublicIP" {
    default = true
}

variable "ansible_public_key" {
  default = ""
}

variable "ec2_amis" {
    default = {
        "eu-west-2" = "ami-096cb92bb3580c759"
    }
}

variable "instance_name" {
       default = "Jokes_EC2"
}

variable "instance_type" {
        default = "t2.micro"
}
