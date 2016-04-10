#
# Cookbook Name:: apt
# Recipe:: default
#
execute "apt-get update" do
  command "apt-get update"
end

package "software-properties-common" do
  action :install
  not_if "dpkg -l | grep -w 'software-properties-common'"
end
