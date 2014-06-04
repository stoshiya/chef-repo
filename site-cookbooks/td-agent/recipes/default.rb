#
# Cookbook Name:: td-agent
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "/tmp/install-redhat.sh" do
  source "http://toolbelt.treasuredata.com/sh/install-redhat.sh"
end

script "install" do
  interpreter "bash"
  user "root"
  code <<-EOL
    sed -i -e 's/^sudo -k/#sudo -k/' -e 's/^sudo sh/sh/' /tmp/install-redhat.sh
    sh /tmp/install-redhat.sh
  EOL
end

service "td-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

