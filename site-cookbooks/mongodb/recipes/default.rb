#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "mongodb.repo" do
  path "/etc/yum.repos.d/mongodb.repo"
  source "mongodb.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

[ "mongodb-org", "mongodb-org-mongos", "mongodb-org-server", "mongodb-org-shell", "mongodb-org-tools" ].each do |p|
  package p do
    action :install
  end
end

service "mongod" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

template "mongod.conf" do
  path "/etc/mongod.conf"
  source "mongod.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :start, 'service[mongod]'
end

