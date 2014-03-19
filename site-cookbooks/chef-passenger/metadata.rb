name             "chef-passenger"
maintainer       "Dwwd Software Inc."
maintainer_email "info@dwwd.ru"
description      "Installs/Configures passenger packages"
version          "0.0.1"

recipe "chef-passenger", "Installs passenger"

supports "ubuntu"

depends "apt"
