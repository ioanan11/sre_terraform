resource "aws_vpc" "sre_ioana_vpc_terraform" {
  cidr_block = "10.103.0.0/16"

  tags = {
      Name = "sre_ioana_vpc_terraform"
  }
}

#resource "aws_subnet" "sre_ioana_subnet_public_terraform" {
  #vpc_id = sre_ioana_vpc_terraform.id
  #cidr_block = "10.103.1.0/24"
  #map_public_ip_on_launch = true
  #availability_zone = "eu-west-1"

  #tags = {
    #Name = "sre_ioana_subnet_public_terraform"
  #}
#}

#resource "aws_subnet" "sre_ioana_subnet_private_terraform" {
  #vpc_id = aws_vpc.sre_ioana_vpc_terraform.id
  #cidr_block = "10.103.2.0/24"
  #map_public_ip_on_launch = false
  #availability_zone = "eu-west-1"

  #tags = {
    #Name = "sre_ioana_subnet_private_terraform"
  #}
#}
