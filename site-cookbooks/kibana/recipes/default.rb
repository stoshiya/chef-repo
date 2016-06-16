#
# Cookbook Name:: kibana
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/yum.repos.d/kibana.repo" do
  path "/etc/yum.repos.d/kibana.repo"
  source "/etc/yum.repos.d/kibana.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

package "kibana" do
  action :install
end

service "kibana" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/opt/kibana/config/kibana.yml" do
  path "/opt/kibana/config/kibana.yml"
  source "/opt/kibana/config/kibana.yml.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :elasticsearch_url => node['kibana']['elasticsearch_url']
  )
  notifies :restart, 'service[kibana]'
end

script "plugins" do
  interpreter "bash"
  user "root"
  code <<-EOL
    for i in `/opt/kibana/bin/kibana plugin --list`
    do
    /opt/kibana/bin/kibana plugin --remove $i
    done

    /opt/kibana/bin/kibana plugin --install elastic/sense
  EOL
  notifies :restart, 'service[kibana]'
end
