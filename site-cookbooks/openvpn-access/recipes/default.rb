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

remote_file "/tmp/vcider_#{version}_#{arch}.deb" do
  source "https://my.vcider.com/m/downloads/vcider_#{version}_#{arch}.deb"
  mode 0644
  checksum "" # PUT THE SHA256 CHECKSUM HERE
end

remote_file "/tmp/#{basename}.deb" do
  owner     'root'
  group     'root'
  mode      '0644'
  # backup    false
  source    "#{base_url}/#{basename}.deb"
  # checksum  checksum if checksum
  # not_if { ::File.exists? "#{src_dir}/#{basename}.deb" }
  # not_if    { ::File.exists?('/usr/local/bin/phantomjs') && `/usr/local/bin/phantomjs --version`.chomp == version }
  # notifies  :run, 'execute[phantomjs-install]', :immediately
end

dpkg_package "openvpn_as" do
  source "/tmp/#{basename}.deb"
  action :install
end
# cookbook_file "/var/chef-package-cache/glusterfs_3.2.1-1_amd64.deb" do
#   source "glusterfs_3.2.1-1_amd64.deb"
#   owner "root"
#   group "root"
#   mode "0444"
# end

# dpkg_package "glusterfs" do
#     case node[:platform]
#     when "debian","ubuntu"
#             package_name "glusterfs"
#             source "/var/chef-package-cache/glusterfs_3.2.1-1_amd64.deb"
#     end
#     action :install
# end
