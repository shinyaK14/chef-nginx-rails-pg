name             "redis-custom"
maintainer       "Dwwd Software Inc."
maintainer_email "info@dwwd.ru"
description      "Installs/Configures Redis"
version          "0.0.1"

recipe "redis-custom", "Installs redis from chris lea's ppa"

supports "ubuntu"

depends "apt"
