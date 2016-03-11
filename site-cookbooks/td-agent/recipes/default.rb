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
    sed -i -e 's/^sudo -k/#sudo -k/' -e 's/^sudo sh/sh/' /tmp/install-redhat-td-agent2.sh
    sh /tmp/install-redhat-td-agent2.sh
  EOL
end

script "install plugin" do
  interpreter "bash"
  user "root"
  code <<-EOL
    /opt/td-agent/usr/sbin/td-agent-gem install fluent-plugin-forest --no-ri --no-rdoc
  EOL
end

directory "/etc/td-agent/conf.d" do
  owner "root"
  mode  0755
end

template "td-agent.conf" do
  path "/etc/td-agent/td-agent.conf"
  source "td-agent.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

service "td-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
