#
# Cookbook Name:: newrelic-infra
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

license_key = "#{node[:'newrelic-infra'][:license_key]}"

remote_file "/etc/yum.repos.d/newrelic-infra.repo" do
  source "https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo"
end

package "newrelic-infra" do
  action :install
end

script "configure" do
  interpreter "bash"
  user "root"
  code <<-EOL
    echo "license_key: YOUR_LICENSE_KEY" | tee -a /etc/newrelic-infra.yml
  EOL
end

service "newrelic-infra" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
