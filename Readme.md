# Rails Nginx Postgres Server Template

## Overview

Chef recipes for deploying Rails applications.

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
