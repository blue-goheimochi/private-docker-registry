#
# Cookbook Name:: ntp
# Recipe:: default
#
package "ntp" do
  action :install
  not_if "dpkg -l | grep -w 'ntp'"
end

execute "set timezone" do
  command <<-EOS
    echo -e 'ZONE="Asia/Tokyo"\nUTC="false"' > /etc/sysconfig/clock
    source /etc/sysconfig/clock
    yes | cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  EOS
  not_if "less /etc/sysconfig/clock | grep 'Asia/Tokyo'"
end

execute "adjust the time" do
  command <<-EOS
    service ntp stop
    ntpdate #{node['ntp']['servers'][0]}
  EOS
  notifies :start, "service[ntp]"
end

service "ntp" do
 supports :status => true, :restart => true
 action :enable
end

template "/etc/ntp.conf" do
  source "ntp.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[ntp]"
end
