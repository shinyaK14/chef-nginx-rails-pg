#
# Cookbook Name:: openvpn-simple
# Recipe:: server
#

package 'openvpn'

if node[:openvpn][:reconfigure]
  template "/etc/openvpn/server.conf" do
    owner "root"
    group "root"
    mode "0644"
    source "server.conf.erb"
  end

  template "/etc/sysctl.conf" do
    owner "root"
    group "root"
    mode "0644"
    source "sysctl.conf"
  end
end

execute "generate the Diffie-Hellman parameters" do
  user "root"
  command "openssl dhparam -out /etc/openvpn/dh2048.pem 2048"
  not_if { ::File.exist?("/etc/openvpn/dh2048.pem") }
end

execute "Cleaning previous keys" do
  user "root"
  command "./clean-all"
  cwd "/etc/openvpn/easy-rsa"
  not_if { ::File.exist?("/etc/openvpn/easy-rsa/keys/ca.crt") }
end

execute "Build CA" do
  user "root"
  command "./pkitool --initca"
  cwd "/etc/openvpn/easy-rsa"
  not_if { ::File.exist?("/etc/openvpn/easy-rsa/keys/ca.crt") }
end

execute "Generate a Certificate and Key for the Server" do
  user "root"
  command "./pkitool --server #{node[:openvpn][:key][:name]}"
  cwd "/etc/openvpn/easy-rsa"
  not_if { ::File.exist?("/etc/openvpn/easy-rsa/keys/#{node[:openvpn][:key][:name]}.crt") }
end

execute "Copy CA" do
  user "root"
  cwd "/etc/openvpn/easy-rsa/keys"
  command "cp ca.crt /etc/openvpn"
  not_if { ::File.exist?("/etc/openvpn/ca.crt") }
end

execute "Copy Server cert" do
  user "root"
  cwd "/etc/openvpn/easy-rsa/keys"
  command "cp #{node[:openvpn][:key][:name]}.crt /etc/openvpn"
  not_if { ::File.exist?("/etc/openvpn/#{node[:openvpn][:key][:name]}.crt") }
end

execute "Copy Server key" do
  user "root"
  cwd "/etc/openvpn/easy-rsa/keys"
  command "cp #{node[:openvpn][:key][:name]}.key /etc/openvpn"
  not_if { ::File.exist?("/etc/openvpn/#{node[:openvpn][:key][:name]}.key") }
end
