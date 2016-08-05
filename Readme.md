# Rails Nginx Postgres Server Template

## v1.0.30

## Overview

Chef recipes for deploying Rails applications.

:exclamation::exclamation::exclamation: This recipes doesn't work on OpenVZ VDS :exclamation::exclamation::exclamation:

### Includes
* basic server provisioning
* nginx server
* passenger nginx configuration
* postgres server
* rvm/rbenv ruby & gems prerequisites
* elasticsearch server
* redis server
* nodejs server
* knife-ec2 gem for AWS EC2 creation
* swap management

### Getting Started

* Install Ruby & gems:

  Using rbenv:
  [`rbenv`](https://github.com/sstephenson/rbenv#basic-github-checkout), [`ruby-build`](https://github.com/sstephenson/ruby-build#installing-as-an-rbenv-plugin-recommended):

  ```shell
  rbenv install $(cat .ruby-version)
  rbenv rehash
  gem install bundler
  rbenv rehash
  bundle install
  ```

  or RVM:
  [`rvm`](http://rvm.io/)

  ```shell
  \curl -sSL https://get.rvm.io | bash -s stable
  rvm install $(cat .ruby-version)
  rvm gemset create $(cat .ruby-gemset)
  bundle install
  ```

* Create JSON config files

  ./nodes/your.server.name.json

  ./data_bags/users/username.json

  Use examples in the data_bags and nodes directories

* Prepare server

  ```shell
  knife solo prepare user@your.server.name
  ```

* Apply recipes

  ```shell
  knife solo cook user@your.server.name
  ```

* Creating EC2 instances with knife

  ```shell
  knife ec2 server create --image=ami-26c43149 --flavor=t2.nano --ssh-key=ssh_key_name --identity-file=~/.ssh/ssh_key.pem --ssh-user ubuntu --region=eu-central-1 --availability-zone=eu-central-1a --groups=ssh,web --tags Name=Test
  ```

  -I --image is the AMI ID

  -f --flavor is the Amazon EC2 instance type

  -S --ssh-key is the name you gave to the SSH key pair generated in the AWS management console

  -i --identity-file points to the private key file of that SSH key pair as downloaded when the key pair was created in the AWS management console

  --ssh-user the official Ubuntu EC2 AMIs use ubuntu as the default user

  --region eu-west-1 If you want your instances to be deployed in any specific Amazon AWS region, add this parameter and the desired region

  -Z --availability-zone eu-west-1a is the availability zone within your region

#### TODO
  * add hostname
  * add monit
  * generate ssh key
