variable "vpc-cidr" {
    type = string
  
}

variable "subnets" {
    type = map(object({
        cidr = string
        az = string
        public = bool
    }))
  
}

variable "route-cidr" {
    type = string
  
}

