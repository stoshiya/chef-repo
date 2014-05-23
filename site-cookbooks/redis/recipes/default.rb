#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "redis" do
  action :install
  options "--enablerepo=epel"
end

service "redis" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

template "redis.conf" do
  path "/etc/redis.conf"
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[redis]'
end

