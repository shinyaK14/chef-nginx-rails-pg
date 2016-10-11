# consistently up to date. We need software-properties-common
# for add-apt-repository to work (python-software-properties doesn't need anymore)
package 'software-properties-common'

bash 'adding stable redis ppa' do
  user 'root'
  code <<-EOC
    add-apt-repository ppa:chris-lea/redis-server
    apt-get update
  EOC
end

package 'redis-server'

# use custom redis configuration file.
template "/etc/redis/redis.conf" do
  owner "root"
  group "root"
  mode "0644"
  source "redis.conf.erb"
  notifies :run, "execute[restart-redis]", :immediately
end

# add an init script to control redis
template "/etc/init.d/redis-server" do
  owner "root"
  group "root"
  mode "0755"
  source "redis-server.erb"
  notifies :run, "execute[restart-redis]", :immediately
end

execute "chown redis:redis /etc/redis"

execute "restart-redis" do
  command "/etc/init.d/redis-server restart"
  action :nothing
end
