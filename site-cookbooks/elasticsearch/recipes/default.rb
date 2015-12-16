#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "elasticsearch.repo" do
  path "/etc/yum.repos.d/elasticsearch.repo"
  source "elasticsearch.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

package "elasticsearch" do
  action :install
end

#template "elasticsearch.yaml" do
#  path "/etc/elasticsearch/elasticsearch.yml"
#  source "elasticsearch.yml.erb"
#  owner "root"
#  group "root"
#  mode 0644
#end

service "elasticsearch" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

script "install plugins" do
  interpreter "bash"
  user "root"
  code <<-EOL
    for i in `/usr/share/elasticsearch/bin/plugin list | grep '^    - ' | sed -e 's/^    -//'`
    do
    /usr/share/elasticsearch/bin/plugin remove $i
    done

    /usr/share/elasticsearch/bin/plugin install cloud-aws
    /usr/share/elasticsearch/bin/plugin install analysis-kuromoji
    /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
    /usr/share/elasticsearch/bin/plugin install royrusso/elasticsearch-HQ
  EOL
  notifies :restart, 'service[elasticsearch]'
end
