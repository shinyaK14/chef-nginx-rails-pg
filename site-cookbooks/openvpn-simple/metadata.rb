name             "openvpn-simple"
maintainer       "Dwwd Software Inc."
maintainer_email "info@dwwd.ru"
description      "Installs/Configures OpenVPN server"
version          "0.0.3"

recipe "openvpn-simple", "Installs/Configures OpenVPN server"

supports 'ubuntu', '>= 14.04'

depends 'apt'
depends 'sysctl'
