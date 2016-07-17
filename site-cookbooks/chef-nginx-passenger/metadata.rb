name             "chef-nginx-passenger"
maintainer       "Dwwd Software Inc."
maintainer_email "info@dwwd.ru"
description      "Installs/Configures Passenger with Nginx"
version          "0.0.2"

recipe "chef-nginx-passenger", "Installs/Configures Passenger with Nginx"

supports "ubuntu"

depends "apt"
