#
# Cookbook Name:: newrelic
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

license_key = "#{node[:newrelic][:license_key]}"

script "rpm" do
  interpreter "bash"
  user "root"
  code <<-EOL
    rpm -Uvh --force https://download.newrelic.com/pub/newrelic/el5/i386/newrelic-repo-5-3.noarch.rpm
    echo "priority=1" >> /etc/yum.repos.d/newrelic.repo
  EOL
end

package "newrelic-sysmond" do
  action :install
end

script "configure" do
  interpreter "bash"
  user "root"
  code <<-EOL
    /usr/sbin/nrsysmond-config --set license_key=#{license_key}
  EOL
end

service "newrelic-sysmond" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
