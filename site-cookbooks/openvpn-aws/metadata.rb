name             "openvpn-aws"
maintainer       "Dwwd Software Inc."
maintainer_email "info@dwwd.ru"
description      "Installs/Configures OpenVPN server"
version          "0.0.1"

recipe "openvpn-aws", "Installs/Configures OpenVPN server"

supports 'ubuntu', '>= 14.04'

depends "apt"
