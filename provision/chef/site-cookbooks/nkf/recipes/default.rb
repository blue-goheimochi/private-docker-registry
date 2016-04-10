#
# Cookbook Name:: nkf
# Recipe:: default
#
package "nkf" do
  action :install
  not_if "dpkg -l | grep -w 'nkf'"
end
