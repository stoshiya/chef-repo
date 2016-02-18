action :create do
  template "/etc/stunnel/conf.d/#{new_resource.name}.conf" do
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
end

