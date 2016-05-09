#
# Cookbook Name:: newrelic-plugin-agent
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

script "install" do
  interpreter "bash"
  user "root"
  code <<-EOL
    pip install newrelic-plugin-agent
    pip install newrelic-plugin-agent[mongodb]
    cp /opt/newrelic-plugin-agent/newrelic-plugin-agent.rhel /etc/rc.d/init.d/newrelic-plugin-agent
    chmod 0755 /etc/rc.d/init.d/newrelic-plugin-agent
  EOL
  not_if {File.exists?("/opt/newrelic-plugin-agent/newrelic-plugin-agent.rhel")}
end

directory "/etc/newrelic" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "newrelic-plugin-agent.cfg" do
  path "/etc/newrelic/newrelic-plugin-agent.cfg"
  source "newrelic-plugin-agent.cfg.erb"
  owner "root"
  group "newrelic"
  mode 0640
  variables(
    :license_key        => node['newrelic']['license_key'],
    :apache_httpd       => node['newrelic-plugin-agent']['apache_httpd'],
    :apache_httpd_name  => node['newrelic-plugin-agent']['apache_httpd_name'],
    :mongodb            => node['newrelic-plugin-agent']['mongodb'],
    :mongodb_name       => node['newrelic-plugin-agent']['mongodb_name'],
    :mongodb_databases  => node['newrelic-plugin-agent']['mongodb_databases'],
    :redis              => node['newrelic-plugin-agent']['redis'],
    :redis_name         => node['newrelic-plugin-agent']['redis_name'],
    :elasticsearch      => node['newrelic-plugin-agent']['elasticsearch'],
    :elasticsearch_name => node['newrelic-plugin-agent']['elasticsearch_name']
  )
end

link "/usr/bin/newrelic-plugin-agent" do
  to "/usr/local/bin/newrelic-plugin-agent"
end

service 'newrelic-plugin-agent' do
  action [ :enable, :start ]
end
