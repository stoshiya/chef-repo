action :create do
  template "#{Chef::Config[:file_cache_path]}/#{new_resource.name}.conf" do
    cookbook "stunnel"
    source "template.conf.erb"
    action :create
    mode 00755
    owner "root"
    group "root"
    variables(
      :name => new_resource.name,
      :port => new_resource.port
    )
  end

  execute "Add config to /etc/stunnel/stunnel.conf" do
    command "cat #{Chef::Config[:file_cache_path]}/#{new_resource.name}.conf >> /etc/stunnel/stunnel.conf"
    only_if { File.exists?("#{Chef::Config[:file_cache_path]}/#{new_resource.name}.conf") }
    notifies :delete,  "template[#{Chef::Config[:file_cache_path]}/#{new_resource.name}.conf]"
    notifies :restart, "service[stunnel]"
  end
end
