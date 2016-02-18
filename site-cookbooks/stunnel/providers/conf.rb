action :create do
  template "/tmp/#{new_resource.name}.conf" do
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
    notifies :restart, "service[stunnel]"
  end

  execute "Add config to /etc/stunnel/stunnel.conf" do
    command "cat /tmp/#{new_resource.name}.conf >> /etc/stunnel/stunnel.conf"
    only_if { File.exists?("/tmp/#{new_resource.name}.conf") }
    notifies :delete,  "template[/tmp/#{new_resource.name}.conf]"
    notifies :restart, "service[stunnel]"
  end
end