#
# Cookbook Name:: openvpn-simple
# Recipe:: clients
#

# ./pkitool client1

execute "Generate a Certificate and Key for the Server" do
  user "root"
  command "./pkitool --server #{node[:openvpn][:key][:name]}"
  cwd "/etc/openvpn/easy-rsa"
  not_if { ::File.exist?("/etc/openvpn/easy-rsa/keys/#{node[:openvpn][:key][:name]}.crt") }
end
