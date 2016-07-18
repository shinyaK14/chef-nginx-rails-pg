#
# Cookbook Name:: chef-passenger
# Recipe:: default
#
# Copyright 2016, Dwwd Software Inc.
#
include_recipe 'apt'

prerequisites = %w(apt-transport-https ca-certificates)
prerequisites.each { |name| package name }

apt_repository 'passenger' do
  uri          'https://oss-binaries.phusionpassenger.com/apt/passenger'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          '561F9B9CAC40B2F7'
  action :add
end

passenger_packages = %w(nginx-extras passenger)
passenger_packages.each { |name| package name }

if node[:nginx][:reconfigure]
  template "/etc/nginx/nginx.conf" do
    owner "root"
    group "root"
    mode "0644"
    source "nginx.conf.erb"
  end
end

# write site configs from templates
all_sites do |site|
  template "/etc/nginx/sites-available/#{site[:server_name]}" do
    owner "#{ site[:app_user] }"
    group "#{ site[:app_user] }"
    mode "0644"
    source "ruby.erb"

    variables({
      server_name: site[:server_name],
      app_user: site[:app_user],
      app_name: site[:app_name],
      app_env: site[:app_env] || "production",
      shared_folder: site[:app_shared_folder_name] || "shared",
      debug_passenger: site[:debug_passenger] || node[:passenger][:debug_passenger],
      max_pool_size: site[:max_pool_size] || node[:passenger][:max_pool_size],
      min_instances: site[:min_instances] || node[:passenger][:min_instances],
      idle_time: site[:idle_time] || node[:passenger][:idle_time],
      app_log_level: site[:app_log_level] || node[:passenger][:app_log_level]
    })

    notifies :run, "execute[restart-nginx]", :immediately
  end

  bash "symlink available site if not exist" do
    user "root"
    code "ln -s /etc/nginx/sites-available/#{site[:server_name]} /etc/nginx/sites-enabled/#{site[:server_name]}"
    not_if { File.exist?("/etc/nginx/sites-enabled/#{site[:server_name]}") }
  end
end

# open web ports
if node[:nginx][:update_ufw_rules]
  bash "allowing nginx traffic through firewall" do
    user "root"
    code "ufw allow 80 && ufw allow 443"
  end
end

execute "restart-nginx" do
  command "/etc/init.d/nginx restart"
  action :nothing
end
