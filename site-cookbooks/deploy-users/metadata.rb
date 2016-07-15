name             "deploy-users"
maintainer       "Dwwd Software Inc."
maintainer_email "info@dwwd.ru"
description      "Manages users from data_bags"
version          "0.0.1"

recipe "deploy-users", "Manages users from data_bags"

supports "ubuntu"

depends "users", '~> 2'
