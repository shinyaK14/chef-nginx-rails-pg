#
# Cookbook Name:: lwrp-postgres
# Recipe:: default
#
# Copyright 2014, Dwwd Software Inc.
#

include_recipe 'postgresql'
include_recipe 'postgresql::server'
include_recipe 'postgresql::client'

data_bag('pg_users').each do |user|
  user_conf = data_bag_item('pg_users', user)
  pg_user user do
    encrypted_password user_conf['secure_password']
    privileges superuser: user_conf["superuser"], createdb: user_conf["createdb"], login: user_conf["login"]
  end
end
