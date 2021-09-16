# Terraform

## What is Terraform

Terraform is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently. This includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc. Terraform can manage both existing service providers and custom in-house solutions.

## Why Terraform

There are a few key reasons developers choose to use Terraform over other Infrastructure as Code tools:

1. **Open source**: Terraform is backed by large communities of contributors who build plugins to the platform. 

2. **Platform agnostic**: Meaning you can use it with any cloud services provider. Most other IaC tools are designed to work with single cloud provider.

3. **Immutable infrastructure**: Terraform provisions immutable infrastructure, which means that with each change to the environment, the current configuration is replaced with a new one that accounts for the change, and the infrastructure is reprovisioned. Even better, previous configurations can be retained as versions to enable rollbacks if necessary or desired.


## Setting up Terraform

- After you download Terraform from https://www.terraform.io/downloads.html, unzip the file and create an environment for it on your local machine.

- From Windows menu search for Environment. 

![alt text](https://github.com/ioanan11/sre_terraform/blob/main/Screenshot%202021-09-16%20101107.png)

- Click on environment variables and add for users and system variables by clicking "New". Add the name and the location where you saved Terraform. 

## Security AWS keys for Terraform

Add the AWS security keys in the env var as done before with Terraform, 

**Note**: name should be AWS_ACCESS_KEY_ID and AWS_SECRET_KEY_ID

## Commands

![alt text](https://github.com/ioanan11/sre_terraform/blob/main/Screenshot%202021-09-16%20103248.png)

# Creating a VPC using IaC Terraform 

![alt text](https://github.com/ioanan11/sre_terraform/blob/main/Screenshot%202021-09-16%20135130.png)

To configure a VPC using Terraform, we need a few things to be coded:

- CIDRblock
- Internet Gateway
- Subnet
- Route Table
- NACL

We will code in main.tf, vpc.tf, network.tf and variable.tf.

Variables will be defined in `variables.tf` and referenced in `main.tf` using `var.resource_name`.
We will use vpc.tf to configure the VPC.
We will use network.tf to configure the IG, subnets, route table and NACLs.

## 1.Configure and launch the VPC

In vpc.tf:

```
resource "aws_vpc" "sre_ioana_vpc_terraform" {
  cidr_block = "10.103.0.0/16"

  tags = {
      Name = "sre_ioana_vpc_terraform"
  }
}

``` 
## 2. Configure IG, subnet, route table and NACLs

### 1. CIDR

```
resource "aws_vpc" "sre_ioana_vpc" {
 cidr_block = 10.103.0.0/16
 instance = "default"
 tags = {
    Name = "sre_ioana_sre"
 }
}

```

## 2. Internet Gateway

```

resource "aws_internet_gateway" "sre_ioana_igw" {
  vpc_id = aws_vpc.sre_ioana_vpc.id

  tags = {
    Name = "sre_ioana_igw"
  }
}

```

## 3. Public Subnet

```
resource "aws_subnet" "sre_ioana_subnet_public" {
  vpc_id = aws_vpc.sre_ioana_vpc.id
  cidr_block = "10.103.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1"

  tags = {
    Name = "sre_ioana_subnet_public"
  }
}

```

## 4. Route Table

```
resource "aws_route_table" "sre_ioana_rt" {
  vpc_id = aws_vpc.sre_ioana_vpc.id

  route 
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.sre_ioana_rt.id
    }


  tags = {
    Name = "sre_ioana_rt"
  }
}
```

## 5. NACL

```
resource "aws_network_acl" "sre_ioana_nacl_public" {
  vpc_id = aws_vpc.main.id

  ingress = [
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }
  ]

  	ingress {
		protocol = "tcp"
		rule_no = 110
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 443
		to_port = 443
	}

  	ingress 
    
    {
		protocol = "tcp"
		rule_no = 120
		action = "allow"
		cidr_block = "${var.my_ip}/32"
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
	

  egress = [
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }
  ]

  	egress {
		protocol = "tcp"
		rule_no = 130
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 1024
		to_port = 65535
	}

	# allow 27017 to private subnet
	egress {
		protocol = "tcp"
		rule_no = 140
		action = "allow"
		cidr_block = "10.103.2.0/24"
		from_port = 27017
		to_port = 27017
	}


  tags = {
    Name = "sre_ioana"
  }
}
```

## 6. Security Group

```
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [aws_vpc.main.cidr_block]
      ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  tags = {
    Name = "allow_tls"
  }
}
```

# Launch an EC2 instance using Iac Terraform 

## Step 1: `main.tf` should contain the following code:

```

# Let's set up our server provider with Terraform

provider "aws" {


    region = "eu-west-1"

}

# Let's start with launching the EC2 instance
# define resource name


resource "aws_instance" "app_instance" {
 ami = "ami-00e8ddf087865b27f"
 instance_type = "t2.micro"
 associate_public_ip_address = true
 tags = {
  Name = "sre_ioana_terraform_app"
 }
}

```

## Step 2: Run the following commands

```
terraform plan
terraform apply

```
