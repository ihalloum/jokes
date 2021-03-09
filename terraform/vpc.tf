# create the VPC
resource "aws_vpc" "Jokes_VPC" {
  cidr_block           = var.vpc_CIDR_block
  instance_tenancy     = "default" 
  enable_dns_support   = true 
  enable_dns_hostnames = true
  tags = {
    Name = "Jokes-VPC"
  }
} 


# create the Subnet
resource "aws_subnet" "Jokes_VPC_Subnet" {
  vpc_id                  = aws_vpc.Jokes_VPC.id
  cidr_block              = var.subnet_CIDR_block
  map_public_ip_on_launch = var.map_PublicIP 
  availability_zone       = var.availability_zone
  tags = {
    Name = "Jokes-Public-Subnet"
  }
} 


# Create the Security Group
resource "aws_security_group" "Jokes_Security_Group" {
  vpc_id       = aws_vpc.Jokes_VPC.id
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingress_CIDR_block  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 
  
  # allow ingress of port 80 for Prod app
  ingress {
    cidr_blocks = var.ingress_CIDR_block  
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # allow ingress of port 22 for ssh
  ingress {
    cidr_blocks = var.ingress_CIDR_block
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # allow ingress of port 5000 for Dev app
  ingress {
    cidr_blocks = var.ingress_CIDR_block
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
  }

  # allow ingress of port 8080 for Jenkins
  ingress {
    cidr_blocks = var.ingress_CIDR_block  
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jokes-VPC-Security-Group"
    Description = "Jokes VPC Security Group"
  }
} 


# Create the Internet Gateway
resource "aws_internet_gateway" "Jokes_VPC_GW" {
  vpc_id = aws_vpc.Jokes_VPC.id
  tags = {
    Name = "Jokes-VPC-Internet-Gateway"
  }
} 

# Create the Route Table
resource "aws_route_table" "Jokes_VPC_route_table" {
  vpc_id = aws_vpc.Jokes_VPC.id
  tags = {
    Name = "Jokes VPC Route Table"
  }
} 


# Create the Internet Access
resource "aws_route" "Jokes_VPC_internet_access" {
  route_table_id         = aws_route_table.Jokes_VPC_route_table.id
  destination_cidr_block = var.destination_CIDR_block
  gateway_id             = aws_internet_gateway.Jokes_VPC_GW.id
} 


# Associate the Route Table with the Subnet
resource "aws_route_table_association" "My_VPC_association" {
  subnet_id      = aws_subnet.Jokes_VPC_Subnet.id
  route_table_id = aws_route_table.Jokes_VPC_route_table.id
}
