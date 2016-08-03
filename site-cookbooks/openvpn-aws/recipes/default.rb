package 'openvpn'
package 'easy-rsa'

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

  template "/etc/default/ufw" do
    owner "root"
    group "root"
    mode "0644"
    source "ufw"
  end

  template "/etc/ufw/before.rules" do
    owner "root"
    group "root"
    mode "0640"
    source "before.rules"
  end
end

bash "enable traffic forwarding" do
  user "root"
  code "echo 1 > /proc/sys/net/ipv4/ip_forward"
  not_if { ::File.foreach("/proc/sys/net/ipv4/ip_forward").grep(/1/).any? }
end
# include_recipe 'sysctl::default'
#
# sysctl_param 'net.ipv4.conf.all.forwarding' do
#   value 1
# end
#
# sysctl_param 'net.ipv6.conf.all.forwarding' do
#   value 1
# end

bash "ufw open port and reload" do
  user "root"
  code "ufw reload"
end

execute "generate the Diffie-Hellman parameters" do
  command "openssl dhparam -out /etc/openvpn/dh2048.pem 2048"
  not_if { ::File.exist?("/etc/openvpn/dh2048.pem") }
end

execute "Configure and Build the Certificate Authority" do
  command "cp -r /usr/share/easy-rsa/ /etc/openvpn"
  not_if { ::Dir.exist?("/etc/openvpn/easy-rsa") }
end

if node[:openvpn][:reconfigure_vars]
  template "/etc/openvpn/easy-rsa/vars" do
    owner "root"
    group "root"
    mode "0644"
    source "vars.erb"
  end
end

directory '/etc/openvpn/easy-rsa/keys' do
  owner 'root'
  group 'root'
  mode  '0755'
end

# source ENV
ENV['EASY_RSA'] = node['openvpn']['key']['easy_rsa']
ENV['OPENSSL'] = node['openvpn']['key']['openssl']
ENV['PKCS11TOOL'] = node['openvpn']['key']['pkcs11_tool']
ENV['GREP'] = node['openvpn']['key']['grep']
ENV['KEY_CONFIG'] = node['openvpn']['key']['key_config']
ENV['KEY_DIR'] = node['openvpn']['key']['key_dir']
ENV['PKCS11_MODULE_PATH'] = node['openvpn']['key']['pkcs11_module_path']
ENV['PKCS11_PIN'] = node['openvpn']['key']['pkcs11_pin']
ENV['CA_EXPIRE'] = node['openvpn']['key']['ca_expire']
ENV['KEY_EXPIRE'] = node['openvpn']['key']['expire']
ENV['KEY_SIZE'] = node['openvpn']['key']['size']
ENV['KEY_COUNTRY'] = node['openvpn']['key']['country']
ENV['KEY_PROVINCE'] = node['openvpn']['key']['region']
ENV['KEY_CITY'] = node['openvpn']['key']['city']
ENV['KEY_ORG'] = node['openvpn']['key']['org']
ENV['KEY_EMAIL'] = node['openvpn']['key']['email']
ENV['KEY_OU'] = node['openvpn']['key']['org_unit']
ENV['KEY_NAME'] = node['openvpn']['key']['name']

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

service 'openvpn' do
  action [:enable, :restart]
end

# ./pkitool client1
