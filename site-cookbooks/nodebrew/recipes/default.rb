#
# Cookbook Name:: nodebrew
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "/tmp/nodebrew" do
  source "http://git.io/nodebrew"
end

execute "setup" do
  user "ec2-user"
  group "ec2-user"
  command <<-EOH
    echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> /home/ec2-user/.bashrc
    export NODEBREW_ROOT=/home/ec2-user/.nodebrew
    perl /tmp/nodebrew setup
    /home/ec2-user/.nodebrew/current/bin/nodebrew install-binary stable
    /home/ec2-user/.nodebrew/current/bin/nodebrew use stable
  EOH
end

