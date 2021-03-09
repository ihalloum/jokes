
# create an EC2 instance
resource "aws_instance" "Jokes_EC2" {
  ami             = lookup(var.ec2_amis, var.aws_region) 
  subnet_id       = aws_subnet.Jokes_VPC_Subnet.id 
  security_groups = [aws_security_group.Jokes_Security_Group.id]
  key_name        = aws_key_pair.Jokes_EC2_key_pair.id
  instance_type   = var.instance_type 
  tags = {
    Name = var.instance_name
  }
 
  volume_tags = {
    Name = var.instance_name
  }
} 

# Sends your public key to the EC2
resource "aws_key_pair" "Jokes_EC2_key_pair" {
  key_name = "Ansible_key_pair"
  public_key = var.ansible_public_key
}
