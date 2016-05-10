#
# Cookbook Name:: td-agent
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

[ "gcc", "gcc-c++", "automake", "autoconf", "libtool", "zlib-devel", "ruby-devel" ].each do |p|
  package p do
    action :install
  end
end

remote_file "/tmp/install-redhat-td-agent2.sh" do
  source "https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh"
end

script "install" do
  interpreter "bash"
  user "root"
  code <<-EOL
    sh /tmp/install-redhat-td-agent2.sh
    /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch
  EOL
end

directory "/etc/td-agent/conf.d" do
  owner "root"
  group "root"
  mode 0755
  recursive true
end

template "td-agent.conf" do
  path "/etc/td-agent/td-agent.conf"
  source "td-agent.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

node['td-agent']['logs'].each do |log|
  template "#{log.dir}-#{log.name}.conf" do
    path "/etc/td-agent/conf.d/#{log.dir}-#{log.name}.conf"
    source "template.tail-in.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :name        => log.name,
      :dir         => log.dir,
      :format      => log.format,
      :time_format => log.time_format,
      :s3                 => node['td-agent']['s3'],
      :s3_bucket          => node['td-agent']['s3_bucket'],
      :s3_region          => node['td-agent']['s3_region'],
      :elasticsearch      => node['td-agent']['elasticsearch'],
      :elasticsearch_host => node['td-agent']['elasticsearch_host'],
      :elasticsearch_port => node['td-agent']['elasticsearch_port']
    )
  end
end

service "td-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
