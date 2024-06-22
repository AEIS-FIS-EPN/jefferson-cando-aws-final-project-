# Final Project for AWS Course

This Terraform project is intended to be used for the final project of the AWS course.

## Getting Started

To begin with this project, follow the instructions below.

### Prerequisites

Make sure you have the following prerequisites installed:

- [Terraform](https://www.terraform.io/downloads.html): Refer to the Installation Guide.

I am using the version 1.8.5 of terraform, you can verify the version with the next coman:
```
$ terraform --version
Terraform v1.8.5
on linux_amd64
```

- AWS Console on your local environment.
- Run `aws configure` in your terminal and provide the access key and secret access key obtained when creating a user in AWS IAM service.

### Summary of the code in main.tf

In our configuration file main.tf, we outline the setup for a Virtual Private Cloud (VPC) with segmented public and private subnets. The VPC is connected to an internet gateway to facilitate external communication. We establish a route table that directs traffic both to the public subnet and through the internet gateway. Additionally, a security group is defined to manage HTTP and HTTPS traffic within the VPC. Our setup includes provisioning an EC2 instance named ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*, configured with a network interface to assign a static IP address. This infrastructure configuration ensures secure and controlled network access while providing necessary connectivity for our applications and services.

### Initialization

Initialize the Terraform project by running the following command:

```
terraform init
```
Prepare your working directory for other commands.
```
terraform validate
```

Check whether the configuration is valid.

```
terraform plan
```
Display changes required by the current configuration.

```
terraform apply
```
Create or update infrastructure.

```
terraform destroy
```

Destroy previously-created infrastructure.


Hope this helps! Let me know if you need further assistance.

