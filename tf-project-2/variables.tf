//name change
variable "name" {
  type = string
  default = "new-vpc"
}


// azs config:
variable "azs-config" {
  type    = string
  default = "eu-east-2"
}


// Nat gateway option
variable "enable_nat_gateway" {
    type = bool
    default = false
}

// internet gateway option
variable "enable_vpn_gateway" {
    type = bool
    default = false
}


// Public Subnets: 
variable "public-subnet-count" {
  type = number

  // Remove default value to ask for user input
  default = 3
}


// Private Subnets: 
variable "private-subnet-count" {
  type = number

  // Remove default value to ask for user input
  default = 3
}
