#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "/tmp/remi-release-6.rpm" do
  source "http://rpms.famillecollet.com/enterprise/remi-release-6.rpm"
end

script "rpm" do
  interpreter "bash"
  user "root"
  code <<-EOL
    rpm -Uvh --force /tmp/remi-release-6.rpm
  EOL
end

package "redis" do
  action :install
  options "--enablerepo=remi"
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
