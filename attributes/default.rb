# Cookbook Name:: pxe_install_server
# Attributes:: default
#
# Author:: Tomokazu Hirai ( @jedipunkz )
#
default['pxe_install_server']['pxeserver_address'] = "192.168.1.0"
default['pxe_install_server']['pxeserver_netmask'] = "255.255.255.0"
default['pxe_install_server']['pxeserver_broadcast'] = "192.168.1.255"
default['pxe_install_server']['pxeserver_range_min'] = "192.168.1.200"
default['pxe_install_server']['pxeserver_range_max'] = "192.168.1.220"
default['pxe_install_server']['pxeserver_router'] = "192.168.1.253"
default['pxe_install_server']['pxeserver_nameserver'] = "8.8.8.8"
default[:pxe_install_server][:releases] = { "ubuntu-12.04" => "precise" }

# add list(s) for your target node(s)
default[:pxe_install_server][:servers] = [
  { :mac => "00:d0:59:cb:71:f3", :release => "ubuntu-12.04", :ip => "192.168.1.200", :hostname => "foo" }
]


