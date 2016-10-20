execute "Adding nodejs source" do
  command "curl -sL https://deb.nodesource.com/setup_#{node['nodejs']['version']}.x | sudo -E bash -"
  user "root"
  not_if { File.exists? "/etc/apt/sources.list.d/nodesource.list" }
end

package 'build-essential'
package 'nodejs' do
  action :upgrade
end
