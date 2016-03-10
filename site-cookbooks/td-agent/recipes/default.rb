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

script "plugin update and install" do
  interpreter "bash"
  user "root"
  code <<-EOL
    sudo /usr/lib64/fluent/ruby/bin/fluent-gem update --no-ri --no-rdoc
    sudo /usr/lib64/fluent/ruby/bin/fluent-gem install fluent-plugin-forest --no-ri --no-rdoc
  EOL
end

service "td-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

