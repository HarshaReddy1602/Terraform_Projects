/* In this project we are 
1) Creating a VPC
2) Creating an internet gateway and assigning it to the VPC
3) Creating Public Subnet
4) Creating Private Subnet
5) Creating Routing Table for both the subnets for traffic flow and associate to their respective subnets
6) Creates a NAT Gateway to enable private subnets to reach out to the internet without any need of an externally routable IP address assigned to each resource.



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

 resource "aws_vpc" "Harsha_VPC" {                
   #Defining CIDR block
   cidr_block       = var.VPC_main     
   instance_tenancy = "default"
 }


 resource "aws_internet_gateway" "Gateway" {    
    vpc_id =  aws_vpc.Harsha_VPC.id               
 }

 resource "aws_subnet" "pubsubnets" {    
   vpc_id =  aws_vpc.Harsha_VPC.id
   cidr_block = "${var.public_subnets}"       
 }
                 
 resource "aws_subnet" "pvtsubnets" {
   vpc_id =  aws_vpc.Harsha_VPC.id
   cidr_block = "${var.private_subnets}"          
 }

 resource "aws_route_table" "PublicRT" {    
    vpc_id =  aws_vpc.Harsha_VPC.id
         route {
    cidr_block = "0.0.0.0/0"               
    gateway_id = aws_internet_gateway.Gateway.id
     }
 }

 resource "aws_route_table" "PrivateRT" {    
   vpc_id = aws_vpc.Harsha_VPC.id
   route {
   cidr_block = "0.0.0.0/0"            
   nat_gateway_id = aws_nat_gateway.NATgateway.id
   }
 }

 resource "aws_route_table_association" "Associating_PublicRT" {
    subnet_id = aws_subnet.pubsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }

 resource "aws_route_table_association" "Associating_PrivateRT" {
    subnet_id = aws_subnet.pvtsubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }
 resource "aws_eip" "EIP" {
   vpc   = true
 }
 
 resource "aws_nat_gateway" "NATgateway" {
   allocation_id = aws_eip.EIP.id
   subnet_id = aws_subnet.pubsubnets.id
 }
