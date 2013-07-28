# Cookbook Name:: pxe_install_server
# Author:: Tomokazu Hirai ( @jedipunkz )
#
# Recipe:: default
#


case node['platform']
when 'debian'
  include_recipe "pxe_install_server::debian"
when 'ubuntu'
  include_recipe "pxe_install_server::ubuntu"
end

