#
# Cookbook Name:: docker
# Attributes:: default
#
default['docker']['repo-url'] = 'https://apt.dockerproject.org/repo'
default['docker']['compose']['install-path'] = '/usr/local/bin/docker-compose'
default['docker']['compose']['download-url'] = 'https://github.com/docker/compose/releases/download/1.6.2/docker-compose'
