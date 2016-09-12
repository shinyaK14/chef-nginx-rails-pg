name             "openvpn-access"
maintainer       "Dwwd Software Inc."
maintainer_email "info@dwwd.ru"
description      "Installs/Configures OpenVPN access server"
version          "0.0.1"

recipe "openvpn-access", "Installs/Configures OpenVPN access server"

supports 'ubuntu', '>= 14.04'

depends 'apt'
