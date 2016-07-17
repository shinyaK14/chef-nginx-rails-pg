#
# Cookbook Name:: chef-passenger
# Recipe:: default
#
# Copyright 2016, Dwwd Software Inc.
#
include_recipe 'apt'

# bash 'Add the Fusion Passenger apt repository' do
#   user 'root'
#   code <<-EOC
#     apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
#     apt-get install apt-transport-https ca-certificates

#     echo deb https://oss-binaries.phusionpassenger.com/apt/passenger precise main >> /etc/apt/sources.list.d/passenger.list

#     chown root: /etc/apt/sources.list.d/passenger.list
#     chmod 600 /etc/apt/sources.list.d/passenger.list
#     apt-get update
#   EOC
# end

# =======
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
# sudo apt-get install -y apt-transport-https ca-certificates
#
# # Add our APT repository
# sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
# sudo apt-get update
#
# # Install Passenger + Nginx
# sudo apt-get install -y nginx-extras passenger
# =======

prerequisites = %w(apt-transport-https ca-certificates)
prerequisites.each { |name| package name }

apt_repository 'passenger' do
  uri          'https://oss-binaries.phusionpassenger.com/apt/passenger'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          '561F9B9CAC40B2F7'
  action :add
end

passenger_packages = %w(nginx-extras passenger)
passenger_packages.each { |name| package name }

template "/etc/nginx/nginx.conf" do
  owner "root"
  group "root"
  mode "0644"
  source "nginx.conf.erb"
end

service "nginx" do
  # supports :status => true, :restart => true, :reload => true
  # action [ :enable, :restart ]
  action :restart
end
