// tf-project-1 dir
module "new-vpc" {
  source = "./tf-project-1"

  name = "new-vpc"

  // Keep azs-config format the same!
  azs-config      = "eu-west-2"

  public-subnet-count = 3
  private-subnet-count = 3

  enable_nat_gateway = true 
  enable_vpn_gateway = true

}


// tf-project-2 dir
module "another-new-vpc" {
  source = "./tf-project-2"

  name = "another-new-vpc"

  // Keep azs-config format the same!
  azs-config      = "eu-east-2"

  public-subnet-count = 2
  private-subnet-count = 2

  enable_nat_gateway = false
  enable_vpn_gateway = true

}