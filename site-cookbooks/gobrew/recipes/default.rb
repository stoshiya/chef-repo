#
# Cookbook Name:: gobrew
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

version = "#{node[:golang][:version]}"

remote_file "/tmp/install.sh" do
  source "https://raw.github.com/grobins2/gobrew/master/tools/install.sh"
end

execute "setup" do
  user "ec2-user"
  group "ec2-user"
  command <<-EOH
    sh /tmp/install.sh
    echo 'export PATH=$HOME/.gobrew/bin:$PATH' >> /home/ec2-user/.bashrc
    export HOME=/home/ec2-user
    eval "$(gobrew init -)"
    /home/ec2-user/.gobrew/bin/gobrew install #{version}
    /home/ec2-user/.gobrew/bin/gobrew use #{version}
  EOH
end

