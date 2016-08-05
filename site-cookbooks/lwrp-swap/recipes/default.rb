#
# Cookbook Name:: lwrp-swap
# Recipe:: default
#

if node[:swap][:enabled]
  swap_file '/mnt/swap' do
    size node[:swap][:size] # MBs
  end
end

if node[:swap][:remove]
  swap_file '/mnt/swap' do
    action :remove
  end
end
