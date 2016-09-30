#
# Cookbook Name:: redis
# Recipe:: sentinel
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "redis::install"

app = "redis-sentinel"

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
      :sentinel_port => node[:redis][:sentinel_port],
      :masterip      => node[:redis][:masterip],
      :masterport    => node[:redis][:masterport],
      :master_name   => node[:redis][:master_name],
      :quorum        => node[:redis][:quorum]
  )
  notifies :restart, "service[#{app}]"
end
