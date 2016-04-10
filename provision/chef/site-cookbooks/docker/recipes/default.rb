#
# Cookbook Name:: docker
# Recipe:: default
#
package "apt-transport-https" do
  action :install
  not_if "dpkg -l | grep -w 'apt-transport-https'"
end

package "ca-certificates" do
  action :install
  not_if "dpkg -l | grep -w 'ca-certificates'"
end

execute "add the new GPG key" do
  command <<-EOS
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  EOS
  not_if "sudo apt-key fingerprint | grep -w 'Docker Release Tool'"
end

template "/etc/apt/sources.list.d/docker.list" do
  source "docker.list.erb"
  owner "root"
  group "root"
  mode "0644"
end

execute "apt-get update" do
  command <<-EOS
    apt-get update
  EOS
end

execute "apt-get purge lxc-docker" do
  command <<-EOS
    apt-get purge lxc-docker
  EOS
end

execute "apt-cache policy docker-engine" do
  command <<-EOS
    apt-cache policy docker-engine
  EOS
end

package "apparmor" do
  action :install
  not_if "dpkg -l | grep -w 'apparmor'"
end

bash "apt-get install linux-image-extra-$(uname -r)" do
  code <<-EOS
    apt-get install linux-image-extra-$(uname -r)
  EOS
  not_if "dpkg -l | grep -w 'linux-image-extra-'"
end

package "docker-engine" do
  action :install
  not_if "dpkg -l | grep -w 'docker-engine'"
end

service "docker" do
 supports :status => true, :restart => true
 action [:enable, :start]
end

bash "install docker-compose" do
  code <<-EOS
    curl -L #{node['docker']['compose']['download-url']}-`uname -s`-`uname -m` > #{node['docker']['compose']['install-path']}
    chmod +x #{node['docker']['compose']['install-path']}
  EOS
  not_if { File.exists?("#{node['docker']['compose']['install-path']}") }
end

# Directory for docker registry
directory "/var/registry" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end
