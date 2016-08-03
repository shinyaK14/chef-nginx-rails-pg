#
# Cookbook Name:: openvpn-simple
# Recipe:: firewall
#

if node[:openvpn][:reconfigure_fw]
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

# bash "enable traffic forwarding" do
#   user "root"
#   code "echo 1 > /proc/sys/net/ipv4/ip_forward"
#   not_if { ::File.foreach("/proc/sys/net/ipv4/ip_forward").grep(/1/).any? }
# end
include_recipe 'sysctl::default'

sysctl_param 'net.ipv4.conf.all.forwarding' do
  value 1
end

sysctl_param 'net.ipv6.conf.all.forwarding' do
  value 1
end

execute "ufw reload" do
  user "root"
  command "ufw reload"
end
