#
# Cookbook Name:: stunnel
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/rc.d/init.d/stunnel" do
  path "/etc/rc.d/init.d/stunnel"
  source "stunnel.rb"
  owner "root"
  group "root"
  mode "755"
end

template "/etc/stunnel/stunnel.conf" do
  path "/etc/stunnel/stunnel.conf"
  source "stunnel.conf.rb"
  owner "root"
  group "root"
  mode "644"
end

package "stunnel" do
  action :install
end

service "stunnel" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
