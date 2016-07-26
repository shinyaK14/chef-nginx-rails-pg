name             "nodejs-lts"
maintainer       "Dwwd Software Inc."
maintainer_email "info@dwwd.ru"
description      "Installs/Configures Node.js & npm"
version          "0.0.1"

recipe "nodejs-lts", "Installs/Configures Node.js & npm"

supports 'ubuntu', '>= 14.04'

depends "apt"
