#
# Cookbook Name:: openvpn-simple
# Recipe:: clients
#

!!node['openvpn']['clients'] && node['openvpn']['clients'].each do |user|
  execute "generating key for user: #{user}" do
    user "root"
    cwd "/etc/openvpn/easy-rsa"
    command "./pkitool #{user}"

    not_if { ::File.exist?("#{node['openvpn']['key']['key_dir']}/#{user}.crt") }
  end

  template "#{node['openvpn']['key']['key_dir']}/#{user}.ovpn" do
    mode "0644"
    source "client.ovpn.erb"
    variables username: user
    # not_if { ::File.exist?("/etc/openvpn/easy-rsa/keys/#{user}.ovpn") }
  end
end
