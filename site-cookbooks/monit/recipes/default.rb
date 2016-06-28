#
# Cookbook Name:: monit
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "monit" do
  action :install
end

template "/etc/monit.conf" do
  path "/etc/monit.conf"
  source "/etc/monit.conf.erb"
  owner "root"
  group "root"
  mode 0600
  notifies :reload, 'service[monit]'
end

node['monit']['targets'].each do |target|
  template "#{target.name}" do
    path "/etc/monit.d/#{target.name}"
    source "/etc/monit.d/template.erb"
    owner "root"
    group "root"
    mode 0600
    variables(
      :name    => target.name,
      :pidfile => target.pidfile
    )
    notifies :reload, 'service[monit]'
  end
end

service "monit" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
