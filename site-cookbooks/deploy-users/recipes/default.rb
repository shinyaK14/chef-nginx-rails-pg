#
# Cookbook Name:: deploy-users
# Recipe:: default
#
# Copyright 2016, Dwwd Software Inc.
#

include_recipe 'users'

users_manage 'deploy' do
  group_id 3000
  action [:remove, :create]
  data_bag 'deploy_users'
end
