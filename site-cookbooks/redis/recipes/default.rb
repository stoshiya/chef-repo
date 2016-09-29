#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "redis::install"

app = "redis"

service "#{app}" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

template "#{app}.conf" do
  path "/etc/#{app}.conf"
  source "/etc/#{app}.conf.erb"
  owner "redis"
  group "root"
  mode 0644
  variables(
      :is_slave    => node[:redis][:is_slave],
      :masterip    => node[:redis][:masterip],
      :masterport  => node[:redis][:masterport]
  )
  notifies :restart, "service[#{app}]"
end
