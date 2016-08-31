#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/yum.repos.d/mongodb.repo" do
  path "/etc/yum.repos.d/mongodb.repo"
  source "/etc/yum.repos.d/mongodb.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

package "mongodb-org" do
  action :install
end

service "mongod" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

template "/etc/mongod.conf" do
  path "/etc/mongod.conf"
  source "/etc/mongod.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[mongod]'
  variables(
    :replSetName => node["mongodb"]["replSetName"]
  )
end

template "/etc/rc.d/init.d/disable-transparent-hugepages" do
  path "/etc/rc.d/init.d/disable-transparent-hugepages"
  source "/etc/rc.d/init.d/disable-transparent-hugepages.erb"
  owner "root"
  group "root"
  mode 0755
  notifies :restart, 'service[mongod]'
end

service "disable-transparent-hugepages" do
  action [ :enable, :start ]
end
