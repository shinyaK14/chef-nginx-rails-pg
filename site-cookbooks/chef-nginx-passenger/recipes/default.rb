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

directory "/etc/nginx/custom" do
  owner "root"
  group "root"
  mode "0644"
  action :create
end

bash "clear existing enabled sites" do
  user "root"
  code "rm /etc/nginx/sites-enabled/*"
end

static_sites do |site|
  if site[:ssl_enabled]
    ssl_conf_for site[:server_name], site[:ssl][:cert], site[:ssl][:key]
  end

  template "/etc/nginx/sites-available/#{site[:server_name]}" do
    owner "#{node[:nginx][:run_user]}"
    group "#{node[:nginx][:run_user]}"
    mode "0644"
    source "static.erb"

    variables({
      server_name: site[:server_name],
      ssl_enabled: site[:ssl_enabled],
      app_user: site[:app_user],
      app_name: site[:app_name]
    })

    notifies :run, "execute[restart-nginx]", :immediately
  end

  symlink_site site[:server_name]
end

passenger_sites do |site|
  # ensure custom conf
  file "/etc/nginx/custom/#{site[:server_name]}" do
    owner "#{node[:nginx][:run_user]}"
    group "#{node[:nginx][:run_user]}"
    mode '0644'
    action :create_if_missing
  end

  if site[:ssl_enabled]
    ssl_conf_for site[:server_name], site[:ssl][:cert], site[:ssl][:key]
  end

  template "/etc/nginx/sites-available/#{site[:server_name]}" do
    owner "#{node[:nginx][:run_user]}"
    group "#{node[:nginx][:run_user]}"
    mode "0644"
    source "ruby.erb"

    variables({
      server_name: site[:server_name],
      ssl_enabled: site[:ssl_enabled],
      app_user: site[:app_user],
      app_name: site[:app_name],
      app_env: site[:app_env] || "production",
      debug_passenger: site[:debug_passenger] || node[:passenger][:debug_passenger],
      min_instances: site[:min_instances] || node[:passenger][:min_instances]
    })

    notifies :run, "execute[restart-nginx]", :immediately
  end

  symlink_site site[:server_name]
end

if !!node[:nginx][:default_site]
  template "/etc/nginx/sites-available/default" do
    owner "#{node[:nginx][:run_user]}"
    group "#{node[:nginx][:run_user]}"
    mode "0644"
    source "500_default.erb"

    variables({
      server_name: node[:nginx][:default_site][:server_name],
      ssl_enabled: node[:nginx][:default_site][:ssl_enabled],
      app_user: node[:nginx][:default_site][:app_user],
      app_name: node[:nginx][:default_site][:app_name]
    })

    notifies :run, "execute[restart-nginx]", :immediately
  end

  symlink_site "default"
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
