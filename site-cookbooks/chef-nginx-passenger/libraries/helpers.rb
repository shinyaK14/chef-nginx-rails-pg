class Chef
  class Recipe
    def passenger_sites(&block)
      node[:nginx][:passenger] && node[:nginx][:passenger].each { |site| block.call(site) }
    end

    def static_sites(&block)
      node[:nginx][:static] && node[:nginx][:static].each { |site| block.call(site) }
    end

    def ssl_conf_for(server_name, cert_body, cert_key)
      directory "/etc/nginx/certs" do
        owner "root"
        group "root"
        mode "0644"
        action :create
      end

      execute "generate the Diffie-Hellman parameters" do
        user "root"
        command "openssl dhparam -out /etc/nginx/dh2048.pem 2048"
        not_if { ::File.exist?("/etc/nginx/dh2048.pem") }
      end

      file "/etc/nginx/certs/#{server_name}.crt" do
        content cert_body
        owner "root"
        group "root"
        mode '0600'
        action :create
      end

      file "/etc/nginx/certs/#{server_name}.key" do
        content cert_key
        owner "root"
        group "root"
        mode '0600'
        action :create
      end
    end

    def symlink_site(server_name)
      bash "symlink available site if not exist" do
        user "root"
        code "ln -s /etc/nginx/sites-available/#{server_name} /etc/nginx/sites-enabled/#{server_name}"
        not_if { File.exist?("/etc/nginx/sites-enabled/#{server_name}") }
      end
    end
  end
end
