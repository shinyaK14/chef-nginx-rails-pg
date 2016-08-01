#log_level                :info
#log_location             STDOUT
#node_name                'flowerett'
#client_key               '/Users/flowerett/dev/devops/chef-nginx-rails-pg/.chef/flowerett.pem'
#validation_client_name   'chef-validator'
#validation_key           '/etc/chef-server/chef-validator.pem'
#chef_server_url          'https://kleinmac:443'
#syntax_check_cache_path  '/Users/flowerett/dev/devops/chef-nginx-rails-pg/.chef/syntax_check_cache'

cookbook_path ["cookbooks", "site-cookbooks"]
node_path     "nodes"
role_path     "roles"
data_bag_path "data_bags"
environment_path "environments"
#encrypted_data_bag_secret "data_bag_key"

ssl_verify_mode :verify_peer

knife[:berkshelf_path] = "cookbooks"
knife[:chef_mode] = "solo"
knife[:aws_config_file] = File.join(ENV['HOME'], "/.aws/config")
knife[:aws_credential_file] = File.join(ENV['HOME'], "/.aws/credentials")
