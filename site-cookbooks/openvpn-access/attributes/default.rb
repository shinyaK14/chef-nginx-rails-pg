default['openvpn_access']['ubuntu_version'] = '14'
default['openvpn_access']['version'] = '2.1.2'
default['openvpn_access']['base_url'] = 'http://swupdate.openvpn.org/as'
default['openvpn_access']['src_dir'] = '/root/src/openvpn_as'
default['openvpn_access']['basename'] = "openvpn-as-#{node['openvpn_access']['version']}-Ubuntu#{node['openvpn_access']['ubuntu_version']}.amd_64"
default['openvpn_access']['checksum'] = nil
