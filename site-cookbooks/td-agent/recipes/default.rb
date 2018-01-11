#
# Cookbook Name:: td-agent
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "/tmp/install-amazon2-td-agent3.sh" do
  source "https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent3.sh"
end

script "install" do
  interpreter "bash"
  user "root"
  code <<-EOL
    sh /tmp/install-amazon2-td-agent3.sh
    /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch
    /usr/sbin/td-agent-gem install fluent-plugin-elb-log
    /usr/sbin/td-agent-gem install fluent-plugin-ec2-metadata
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
  source "/etc/td-agent/td-agent.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

node['td-agent']['logs'].each do |log|
  template "#{log.dir}-#{log.name}.conf" do
    path "/etc/td-agent/conf.d/#{log.dir}-#{log.name}.conf"
    source "/etc/td-agent/conf.d/template.tail.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :name        => log.name,
      :dir         => log.dir,
      :format      => log.format,
      :time_format => log.time_format,
      :s3        => node['td-agent']['s3'],
      :s3_bucket => node['td-agent']['s3_bucket'],
      :s3_region => node['td-agent']['s3_region'],
      :elasticsearch              => node['td-agent']['elasticsearch'],
      :elasticsearch_host         => node['td-agent']['elasticsearch_host'],
      :elasticsearch_port         => node['td-agent']['elasticsearch_port'],
      :elasticsearch_index_prefix => node['td-agent']['elasticsearch_index_prefix'],
    )
  end
end

node['td-agent']['elb_logs'].each do |elb|
  template "#{elb.name}.conf" do
    path "/etc/td-agent/conf.d/#{elb.name}-elb_log.conf"
    source "/etc/td-agent/conf.d/template.elb_log.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :name          => elb.name,
      :s3_bucketname => elb.s3_bucketname,
      :s3_prefix     => elb.s3_prefix,
      :s3_region             => node['td-agent']['s3_region'],
      :elasticsearch_host    => node['td-agent']['elasticsearch_host'],
      :elasticsearch_port    => node['td-agent']['elasticsearch_port'],
      :aws_access_key_id     => node['td-agent']['aws_access_key_id'],
      :aws_secret_access_key => node['td-agent']['aws_secret_access_key'],
    )
  end
end

service "td-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
