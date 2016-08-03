default['openvpn']['reconfigure'] = false
default['openvpn']['reconfigure_vars'] = false

default['openvpn']['key']['easy_rsa'] = "/etc/openvpn/easy-rsa" #'EASY_RSA'
default['openvpn']['key']['openssl'] = "openssl" #'OPENSSL'
default['openvpn']['key']['pkcs11_tool'] = "pkcs11-tool" #PKCS11TOOL
default['openvpn']['key']['grep'] = "grep" #GREP
default['openvpn']['key']['key_config'] = "#{node['openvpn']['key']['easy_rsa']}/openssl-1.0.0.cnf" #KEY_CONFIG
default['openvpn']['key']['key_dir'] = "#{node['openvpn']['key']['easy_rsa']}/keys" #KEY_DIR
default['openvpn']['key']['pkcs11_module_path'] = "dummy" #PKCS11_MODULE_PATH
default['openvpn']['key']['pkcs11_pin'] = "dummy" #PKCS11_PIN

default['openvpn']['key']['ca_expire'] = "3650"
default['openvpn']['key']['expire'] = "3650"
default['openvpn']['key']['size'] = "2048"

default['openvpn']['key']['country'] = "US"
default['openvpn']['key']['region'] = "CA"
default['openvpn']['key']['city'] = "SanFrancisco"
default['openvpn']['key']['org'] = "Fort-Funston"
default['openvpn']['key']['email'] = "me@myhost.mydomain"
default['openvpn']['key']['org_unit'] = "MyOrganizationalUnit"
default['openvpn']['key']['name'] = "EasyRSA"
