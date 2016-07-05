#
# Cookbook Name:: mackerel-agent
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "rpm" do
  command "curl -fsSL https://mackerel.io/file/script/amznlinux/setup-yum.sh | sh"
end

package "mackerel-agent" do
  action :install
end

package "mackerel-agent-plugins" do
  action :install
end

service "mackerel-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

template "/etc/mackerel-agent/mackerel-agent.conf" do
  path "/etc/mackerel-agent/mackerel-agent.conf"
  source "/etc/mackerel-agent/mackerel-agent.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :apikey => node['mackerel-agent']['apikey'],
    :roles  => node['mackerel-agent']['roles']
  )
  notifies :start, 'service[mackerel-agent]'
end
