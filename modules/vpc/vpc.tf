resource "aws_vpc" "demo-vpc" {
    cidr_block = var.vpc-cidr
    enable_dns_hostnames = true
    enable_dns_support = true
}

resource "aws_internet_gateway" "demo-igw" {
    vpc_id = aws_vpc.demo-vpc.id
  
}

resource "aws_subnet" "demo-subnet" {
    for_each = var.subnets
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    map_public_ip_on_launch = each.value.public
}

resource "aws_route_table" "demo-pub-route" {
    vpc_id = aws_vpc.demo-vpc.id
    route {
        cidr_block = var.route-cidr
        gateway_id = aws_internet_gateway.demo-igw.id
    }
  
}

resource "aws_route_table_association" "demo-pub-rtba" {
    for_each = {for key, subnet in var.subnets : key => subnet if subnet.public == true }
    subnet_id = aws_subnet.demo-subnet[each.key].id
    route_table_id = aws_route_table.demo-pub-route.id
  
}

resource "aws_eip" "demo-eip" {
    domain = "vpc"
  
}

resource "aws_nat_gateway" "demo-nat" {
    allocation_id = aws_eip.demo-eip.id
    subnet_id = aws_subnet.demo-subnet["public 1"].id
  
}

resource "aws_route_table" "demo-pri-route" {
    vpc_id = aws_vpc.demo-vpc.id
    route {
        nat_gateway_id = aws_nat_gateway.demo-nat.id
        cidr_block = var.route-cidr
    }
  
}

resource "aws_route_table_association" "demo_pri-rtba" {
    route_table_id = aws_route_table.demo-pri-route.id
    for_each = {for key, subnet in var.subnets : key => subnet if subnet.public == false }
    subnet_id = aws_subnet.demo-subnet[each.key].id
  
}