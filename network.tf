resource "aws_internet_gateway" "sre_ioana_IG_terraform" {
  vpc_id = aws_vpc.sre_ioana_vpc_terraform.id

  tags = {
    Name = "sre_ioana_IG_terra"
  }
}

resource "aws_route_table" "sre_ioana_RT_terraform" {
  vpc_id = aws_vpc.sre_ioana_vpc_terraform.id

  route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.sre_ioana_IG_terraform.id
    }

  tags = {
    Name = "sre_ioana_RT_terraform"
  }
}


#resource "aws_route_table_association" "sre_ioana_subnet_association" {
  #route_table_id = aws_route_table.sre_ioana_RT_terraform.id
  #subnet_id = aws_subnet.sre_ioana_subnet_public_terraform.id
#}

resource "aws_network_acl" "sre_ioana_public_nacl_terra" {
	vpc_id = aws_vpc.sre_ioana_vpc_terraform.id

	
	ingress {
		protocol = "tcp"
		rule_no = 100
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 80
		to_port = 80
	}

	
	ingress {
		protocol = "tcp"
		rule_no = 110
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 443
		to_port = 443
	}

	
	ingress {
		protocol = "tcp"
		rule_no = 120
		action = "allow"
		cidr_block = var.my_ip
		from_port = 22
		to_port = 22
	}

	
	ingress {
		protocol = "tcp"
		rule_no = 130
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 1024
		to_port = 65535
	}
	
	
	egress {
		protocol = "tcp"
		rule_no = 100
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 80
		to_port = 80
	}

	
	egress {
		protocol = "tcp"
		rule_no = 110
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 443
		to_port = 443
	}

	
	egress {
		protocol = "tcp"
		rule_no = 120
		action = "allow"
		cidr_block = var.my_ip
		from_port = 22
		to_port = 22
	}

	
	egress {
		protocol = "tcp"
		rule_no = 130
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 1024
		to_port = 65535
	}

	
	egress {
		protocol = "tcp"
		rule_no = 140
		action = "allow"
		cidr_block = "10.104.2.0/24"
		from_port = 27017
		to_port = 27017
	}

	tags = {
		Name = "sre_ioana_nacl_public_terraform"
	}
}
