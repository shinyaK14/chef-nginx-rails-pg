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

Use examples in the data_bags directory
