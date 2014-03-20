#
# Cookbook Name:: lwrp-postgres
# Recipe:: default
#
# Copyright 2014, Dwwd Software Inc.
#

include_recipe 'postgresql'
include_recipe 'postgresql::server'
include_recipe 'postgresql::client'
include_recipe 'postgresql::server_dev'

data_bag('pg_users').each do |user|
  user_conf = data_bag_item('pg_users', user)
  pg_user user do
    encrypted_password user_conf['secure_password']
    privileges superuser: user_conf["superuser"], createdb: user_conf["createdb"], login: user_conf["login"]
  end
end

data_bag('pg_databases').each do |db|
  db_conf = data_bag_item('pg_databases', db)

  # create a database
  pg_database db do
    owner db_conf['onwer']
    encoding db_conf['encoding']
    template db_conf['template']
    locale db_conf['locale']
  end

  # install extensions to database
  pg_database_extensions db do
    languages "plpgsql"
    extensions db_conf['extensions']
  end
end