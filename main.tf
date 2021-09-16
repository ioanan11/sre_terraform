# Let's set up our server provider with Terraform

provider "aws" {
   

    region = var.region

}

# Let's start with launching the EC2 instance
# define resource name


#resource "aws_instance" "app_instance" {
 #ami = "ami-00e8ddf087865b27f"
 #instance_type = "t2.micro"
 #associate_public_ip_address = true
 #tags = {
  #Name = "sre_ioana_terraform_app"
 #}
#}








         
