#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/yum.repos.d/elasticsearch.repo" do
  path "/etc/yum.repos.d/elasticsearch.repo"
  source "/etc/yum.repos.d/elasticsearch.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

package "elasticsearch" do
  action :install
end

template "/etc/elasticsearch/elasticsearch.yml" do
  path "/etc/elasticsearch/elasticsearch.yml"
  source "/etc/elasticsearch/elasticsearch.yml.erb"
  owner "root"
  group "elasticsearch"
  mode 0640
  variables(
    :network_host => node['elasticsearch']['network_host']
  )
  notifies :restart, 'service[elasticsearch]'
end

template "/etc/sysconfig/elasticsearch" do
  path "/etc/sysconfig/elasticsearch"
  source "/etc/sysconfig/elasticsearch.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :es_heap_size      => node['elasticsearch']['es_heap_size'],
    :max_locked_memory => node['elasticsearch']['max_locked_memory'],
    :max_open_files    => node['elasticsearch']['max_open_files']
  )
  notifies :restart, 'service[elasticsearch]'
end

service "elasticsearch" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

script "plugins" do
  interpreter "bash"
  user "root"
  code <<-EOL
    for i in `/usr/share/elasticsearch/bin/plugin list | grep '^    - ' | sed -e 's/^    -//'`
    do
    /usr/share/elasticsearch/bin/plugin remove $i
    done

    /usr/share/elasticsearch/bin/plugin install analysis-kuromoji
  EOL
  notifies :restart, 'service[elasticsearch]'
end
