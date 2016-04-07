#
# Cookbook Name:: redis
# Recipe:: install
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

script "rpm" do
  interpreter "bash"
  user "root"
  code <<-EOL
    rpm -Uvh --force http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
  EOL
end

package "#{app}" do
  action :install
  options "--enablerepo=remi"
end
