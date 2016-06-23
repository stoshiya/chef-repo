#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

script "rpm" do
  interpreter "bash"
  user "root"
  code <<-EOL
    rpm -Uvh --force https://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    sed -i -e "s/\/packages\//\/packages\/mainline\//" /etc/yum.repos.d/nginx.repo
    echo "priority=1" >> /etc/yum.repos.d/nginx.repo
  EOL
end

package "nginx" do
  action :install
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/nginx/conf.d/default.conf" do
  path "/etc/nginx/conf.d/default.conf"
  source "/etc/nginx/conf.d/default.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :upstream        => node['nginx']['upstream'],
    :upstream_name   => node['nginx']['upstream_name'],
    :upstream_server => node['nginx']['upstream_server']
  )
  notifies :reload, 'service[nginx]'
end
