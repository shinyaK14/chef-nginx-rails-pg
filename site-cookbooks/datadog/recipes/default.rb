bash 'Add the New Relic apt repository' do
  user 'root'
  code <<-EOC
    DD_API_KEY=#{node[:datadog][:api_key]} bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)"
  EOC
end
