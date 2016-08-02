package 'openvpn'
package 'easy-rsa'

if node[:openvpn][:reconfigure]
  template "/etc/openvpn/server.conf" do
    owner "root"
    group "root"
    mode "0644"
    source "server.conf"
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
  # user "root"
  command "openssl dhparam -out /etc/openvpn/dh2048.pem 2048"
  not_if { ::File.exist?("/etc/openvpn/dh2048.pem") }
  # action :nothing
end

execute "Configure and Build the Certificate Authority" do
  # user "root"
  command "cp -r /usr/share/easy-rsa/ /etc/openvpn"
  not_if { ::Dir.exist?("/etc/openvpn/easy-rsa") }
  # action :nothing
end

template "/etc/openvpn/easy-rsa/vars" do
  owner "root"
  group "root"
  mode "0644"
  source "vars.erb"
end

directory '/etc/openvpn/easy-rsa/keys' do
  owner 'root'
  group 'root'
  mode  '0755'
end

execute "Initialize the PKI (Public Key Infrastructure)" do
  command "cd /etc/openvpn/easy-rsa"
  command "source ./vars"
  command "./clean-all"
  command "./build-ca" # fails here!!!
  not_if { ::File.exist?("/etc/openvpn/easy-rsa/keys/ca.crt") }
end

execute "Generate a Certificate and Key for the Server" do
  command "cd /etc/openvpn/easy-rsa"
  command "./build-key-server #{node[:openvpn][:key][:name]}" # fails here!!!
  command "cp /etc/openvpn/easy-rsa/keys/{#{node[:openvpn][:key][:name]}.crt,#{node[:openvpn][:key][:name]}.key,ca.crt} /etc/openvpn"
  not_if { ::File.exist?("/etc/openvpn/#{node[:openvpn][:key][:name]}.crt") }
end

service 'openvpn' do
  action [:enable, :start]
  # action :restart
end

# Aug  2 16:26:09 ip-10-1-0-25 pollinate[26243]: system was previously seeded at [2016-08-02 11:59:45.927983000 +0000]
# Aug  2 16:26:09 ip-10-1-0-25 pollinate[26247]: To re-seed this system again, use the -r|--reseed option
# Aug  2 16:26:11 ip-10-1-0-25 ovpn-server[27575]: Options error: --cert fails with 'server.crt': No such file or directory
# Aug  2 16:26:11 ip-10-1-0-25 ovpn-server[27575]: Options error: --key fails with 'server.key': No such file or directory
# Aug  2 16:26:11 ip-10-1-0-25 ovpn-server[27575]: Options error: Please correct these errors.
# Aug  2 16:26:11 ip-10-1-0-25 ovpn-server[27575]: Use --help for more information.
