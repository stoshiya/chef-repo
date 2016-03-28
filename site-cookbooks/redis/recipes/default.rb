#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

script "rpm" do
  interpreter "bash"
  user "root"
  code <<-EOL
    rpm -Uvh --force http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
  EOL
end

package "redis" do
  action :install
  options "--enablerepo=remi"
end

["redis", "redis-sentinel"].each do |app|
  service "#{app}" do
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end
end

["redis", "redis-sentinel"].each do |app|
  template "#{app}.conf" do
    path "/etc/#{app}.conf"
    source "#{app}.conf.erb"
    owner "redis"
    group "root"
    mode 0644
    variables(
        :is_slave    => node[:redis][:is_slave],
        :masterip    => node[:redis][:masterip],
        :masterport  => node[:redis][:masterport],
        :master_name => node[:redis][:master_name]
    )
    notifies :restart, "service[#{app}]"
  end
end
