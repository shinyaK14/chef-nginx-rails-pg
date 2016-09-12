#
# Cookbook Name:: openvpn-access
# Recipe:: default
#

version  = node['openvpn_access']['version']
base_url = node['openvpn_access']['base_url']
src_dir  = node['openvpn_access']['src_dir']
basename = node['openvpn_access']['basename']
checksum = node['openvpn_access']['checksum']

directory '/root/src' do
  mode    '0755'
  owner   'root'
  group   'root'
end

directory src_dir do
  mode    '0755'
  owner   'root'
  group   'root'
end

remote_file "/#{src_dir}/#{basename}.deb" do
  owner     'root'
  group     'root'
  mode      '0644'
  source    "#{base_url}/#{basename}.deb"
  checksum  checksum if checksum
  not_if { ::File.exists? "#{src_dir}/#{basename}.deb" }
end

dpkg_package "openvpn_as" do
  source "/#{src_dir}/#{basename}.deb"
  action :install
  not_if    { ::File.exists?('/usr/local/openvpn_as/sbin/openvpn-openssl') }
end
