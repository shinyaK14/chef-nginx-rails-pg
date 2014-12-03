cookbook_path ["cookbooks", "site-cookbooks"]
node_path     "nodes"
role_path     "roles"
data_bag_path "data_bags"
environment_path "environments"
#encrypted_data_bag_secret "data_bag_key"

ssl_verify_mode :verify_peer

knife[:berkshelf_path] = "cookbooks"
