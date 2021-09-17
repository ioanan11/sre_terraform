# Let's set up our server provider with Terraform

provider "aws" {
   

    region = var.region

}

# Let's start with launching the EC2 instance
# define resource name


# Let's set up the app instance

resource "aws_instance" "app_instance" {
 ami = "ami-04b3766b32ff36923"
 instance_type = "t2.micro"
 associate_public_ip_address = true
 key_name = var.aws_key_name
 #subnet_id = var.subnet_id
 vpc_security_group_ids = [var.app_sg]
 tags = {
  Name = "sre_ioana_terraform_app"
 }
}
 

# Let's set up the db instance

resource "aws_instance" "db_instance" {
	ami = "ami-0c20239d42e47755c"
	#subnet_id = var.private_subnet_id
	instance_type =  "t2.micro"
	key_name = var.aws_key_name
	associate_public_ip_address = false
	vpc_security_group_ids = [var.db_sg]
	tags = {
		Name = "sre_ioana_terraform_db"
	}
}





         
