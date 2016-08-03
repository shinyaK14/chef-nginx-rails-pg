#
# Cookbook Name:: openvpn-simple
# Recipe:: default
#

include_recipe 'openvpn-simple::firewall'
include_recipe 'openvpn-simple::easy_rsa'
include_recipe 'openvpn-simple::server'
include_recipe 'openvpn-simple::clients'

service 'openvpn' do
  action [:enable, :restart]
end
