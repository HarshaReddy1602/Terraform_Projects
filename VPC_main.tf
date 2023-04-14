#terraform version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configuring the provider details, here i am using AWS
provider "aws" {
  region = "us-east-1"
}
# Creating the VPC
 resource "aws_vpc" "Harsha_VPC" {                
   #Defining CIDR block
   cidr_block       = var.VPC_main     
   instance_tenancy = "default"
 }
# Creating Internet Gateway and assigning to VPC

 resource "aws_internet_gateway" "Gateway" {    
    vpc_id =  aws_vpc.Harsha_VPC.id               
 }
# Creating a Public Subnets.
 resource "aws_subnet" "publicsubnets" {    
   vpc_id =  aws_vpc.Harsha_VPC.id
   cidr_block = "${var.public_subnets}"       
 }
# Creating a Private Subnet                  
 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.Harsha_VPC.id
   cidr_block = "${var.private_subnets}"          
 }
# defining Route table for Public Subnet's
 resource "aws_route_table" "PublicRT" {    
    vpc_id =  aws_vpc.Harsha_VPC.id
         route {
    cidr_block = "0.0.0.0/0"               
    gateway_id = aws_internet_gateway.Gateway.id
     }
 }
 # defining Route table for Private Subnet's
 resource "aws_route_table" "PrivateRT" {    
   vpc_id = aws_vpc.Harsha_VPC.id
   route {
   cidr_block = "0.0.0.0/0"            
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }
 }
 # Route table Association with Public Subnet's
 resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }
 # Route table Association with Private Subnet's
 resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }
 resource "aws_eip" "nateIP" {
   vpc   = true
 }
 # Creating the NAT Gateway using subnet_id and allocation_id
 resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.publicsubnets.id
 }
