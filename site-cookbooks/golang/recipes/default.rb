#
# Cookbook Name:: golang
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

version = "#{node[:golang][:version]}"

remote_file "/tmp/go#{version}.linux-amd64.tar.gz" do
  source "https://storage.googleapis.com/golang/go#{version}.linux-amd64.tar.gz"
end

script "extract" do
  interpreter "bash"
  user "root"
  code <<-EOL
    tar zxvf /tmp/go#{version}.linux-amd64.tar.gz -C /usr/local/
  EOL
end

link "/usr/bin/go" do
  to "/usr/local/go/bin/go"
end

link "/usr/bin/godoc" do
  to "/usr/local/go/bin/godoc"
end

link "/usr/bin/gofmt" do
  to "/usr/local/go/bin/gofmt"
end
