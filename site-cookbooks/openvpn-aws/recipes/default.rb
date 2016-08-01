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
  # not_if { File.exist?("/etc/nginx/sites-enabled/#{site[:server_name]}") }
  # # cat /proc/sys/net/ipv4/ip_forward
  # 1
end

bash "ufw reload" do
  user "root"
  code "ufw reload"
end
