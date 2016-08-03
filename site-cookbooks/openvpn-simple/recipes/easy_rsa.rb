#
# Cookbook Name:: openvpn-simple
# Recipe:: easy_rsa
#

package 'easy-rsa'

execute "Configure and Build the Certificate Authority" do
  user "root"
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
