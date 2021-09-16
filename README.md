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

We will code in main.tf and variable.tf.

Variables will be defines in `variables.tf` and referenced in `main.tf` using `var.resource_name`.

## 1. CIDR

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


