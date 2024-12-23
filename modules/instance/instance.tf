resource "aws_instance" "demo-inst" {
    ami = var.ami
    key_name = "Cloudops"
    instance_type = var.instance
    subnet_id = var.subnet
  
}

resource "aws_security_group" "demo-sg" {
    vpc_id = var.vpc
    name = "demo-sg"
    description = "demo-sg"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}