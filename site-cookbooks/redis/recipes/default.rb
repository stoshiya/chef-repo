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
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

