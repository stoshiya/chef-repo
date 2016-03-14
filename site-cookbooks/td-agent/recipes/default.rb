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

execute "install" do
  command "sh /tmp/install-redhat-td-agent2.sh"
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

node['td-agent']['config'].each do |config|
  template "#{config.dir}-#{config.name}.conf" do
    path "/etc/td-agent/conf.d/#{config.dir}-#{config.name}.conf"
    source "template.s3.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :name =>        config.name,
      :dir =>         config.dir,
      :time_format => config.time_format,
      :s3_bucket => node['td-agent']['s3_bucket'],
      :s3_region => node['td-agent']['s3_region']
    )
  end
end

service "td-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
