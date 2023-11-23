# Terraform Intro

Create separate directories for your tutorial code and the rest of the code you are asked to create so that your infrastructure doesn't clash with each other.

## Summary

## Prerequisites

You should have an understanding of the concept of [Infrastructure as Code](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code) before working on this task.

The first step will get you set up an installed with everything you need. If this is the first time you are provisioning infrastructure from outside the console, you will need to install and authenticate your CLI.

To install the AWS CLI. Consult the docs on how to install for your OS [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). Confirm this is installed by running `aws --version`.

Next we need to authenticate your CLI to be able to contact your AWS account.

You can do this by going to the start url [here](https://d-9c670d407f.awsapps.com/start#/), logging into you account and instead of clicking `Management Console`, instead selecting `Command line or programmatic access`. This will open up a modal with multiple options for authenticating. We are going to use the first option. Simply click the credentials in Option 1 to copy them to your clipboard then paste them directly into the terminal you will be using.

This authentication will last for about 30 minutes each time unless you run some terraform code which will then fetch a refresh token. You can check you have been authenticated correctly by running `aws sts get-caller-identity`. You should receive back a JSON object with your AWS email.

## Overview

This sprint will get you comfortable with creating infrastructure using Terraform to understand the basic concepts of infrastructure as code. Terraform is just one tool that falls under this umbrella but its a useful one for programmatically creating resources and networks.

This sprint will begin with you completing the official Terraform tutorial before moving onto some more intermediate tasks to stretch your understanding.

### Golden Rule

When creating resources with Terraform, we should only ever modify or destroy them using Terraform in future. This is to manage drift between the 2 configurations.

### Tearing things down

It's important to remove our infrastructure when it's no longer necessary. With Terraform, we can do this using the `terraform destroy` command in the directory of our Terraform code. This command will remove any resources you have provisioned but leave your code untouched and ready to be provisioned once more when you are ready.

## Repo

Clone this repo down and create separate directories for your tutorial code and your sprint code.

[ce-terraform-intro](https://github.com/northcoders/ce-terraform-intro)

## 1. Tutorial Level

Work through the [official Terraform Tutorial](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) to familiarise yourself with the syntax.

### READ FIRST

- Once installed, move straight onto to the Build section. You do not need to do the quick start tutorial with Docker.

- When the tutorial asks you to export your AWS credentials first sign in to AWS using [this page](https://d-9c670d407f.awsapps.com/start#/). Once signed in, click `AWS Account (1)` and select `Command line or programmatic access`.

  Once opened you can copy the credentials from Option 1 directly into the terminal you will be using. This will authenticate your CLI for about 30 minutes or so. This will be refreshed every time Terraform contacts AWS though.

  If your authentication times out, refresh that page and repeat.

- You do not need to do the remote state section at the end as we will cover this later in more depth.

## 2. Once more with feeling

Using your new skills it's time to create that production ready VPC in terraform

In this directory, create your **main.tf** file.

Your terraform config should include:

- A VPC with the correct private IP address space CIDR range
- 6 subnets in total
  - 3 public subnets, one in each availability zone
  - 3 private subnets, one in each availability zone
- An Internet Gateway
- A route table that can direct local traffic as well as external traffic
  - The route table should be attached to your public subnets

Make sure to commit and push your code at this point

## 3. Around and around

Let's now refactor - In Software Development, we like to keep our code [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), the same is true of Infrastructure as Code.

Terraform allows us to create loops much like we can in other languages to cut down on the code we write.

Refactor your code so that you only make one resource block for 3 private subnets and one for 3 public subnets.

Make sure to commit and push your code at this point

[Terraform loops and tricks](https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)

## 4. Variables

Refactor your code so that all hardcoded values are replaced by variables.

[Terraform variables](https://developer.hashicorp.com/terraform/language/values/variables)

## 5. Modules

Let's take things even further - people have made it even easier to write terraform by providing re-usable [modules](https://developer.hashicorp.com/terraform/language/modules) which means less boiler plater code for you to write.

Refactor your code to utilise the [AWS VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)

[Terraform module library](https://registry.terraform.io/browse/modules)

## 6. You can do that?

Provision an EC2 instance in one of your public subnets that you can SSH into.

To achieve this you will need to consider the following;

- Key pair for SSH (create this via CLI rather than Terraform) - [Creating a key pair via CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html)
- Security Groups

Separate your code into different files such as **igw.tf** for the internet gateway and **sg.tf** for the security groups.

Separation of concerns is good practice to keep your projects clean and easy to navigate.

## Conclusion

Terraform is a type of Infrastructure as Code called a Desired State Configuration. It is declarative code in which we describe what we wish to end up with and something else will decide the operations needed to achieve that.

Terraform allows us to automate much more of our processes when working with infrastructure and allows us to share parts of our infrastructure to other people. This means it is far more auditable, reusable, and creates a much more consistent infrastructure across your network.
