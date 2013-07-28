# Cookbook Name:: pxe_install_server
# Attributes:: default
#
# Author:: Tomokazu Hirai ( @jedipunkz )
#
default['pxe_install_server']['pxeserver_service_host'] = "192.168.1.251"
default['pxe_install_server']['pxeserver_address'] = "192.168.1.0"
default['pxe_install_server']['pxeserver_netmask'] = "255.255.255.0"
default['pxe_install_server']['pxeserver_broadcast'] = "192.168.1.255"
default['pxe_install_server']['pxeserver_range_min'] = "192.168.1.200"
default['pxe_install_server']['pxeserver_range_max'] = "192.168.1.220"
default['pxe_install_server']['pxeserver_router'] = "192.168.1.253"
default['pxe_install_server']['pxeserver_nameserver'] = "8.8.8.8"
#default[:pxe_install_server][:releases] = [
#    { "ubuntu-12.04" => "precise" },
#    { "debian-6.05" => "squeeze" }
#]
default[:pxe_install_server][:releases] = [
    { :dist => "ubuntu-12.04-amd64", :path => "http://archive.ubuntu.com/ubuntu/dists/precise/main/installer-amd64/current/images/netboot/netboot.tar.gz" },
    { :dist => "ubuntu-12.04-i386", :path => "http://archive.ubuntu.com/ubuntu/dists/precise/main/installer-i386/current/images/netboot/netboot.tar.gz" },
    { :dist => "debian-7.1-amd64", :path => "http://ftp.debian.org/debian/dists/wheezy/main/installer-amd64/current/images/netboot/netboot.tar.gz" }
]

# add list(s) for your target node(s)
default[:pxe_install_server][:servers] = [
  { :mac => "00:d0:59:cb:71:f3", :release => "ubuntu-12.04-i386", :ip => "192.168.1.191", :hostname => "oldrocket" },
  { :mac => "00:1c:25:74:ef:79", :release => "debian-7.1-amd64", :ip => "192.168.1.190", :hostname => "rocket" },
  { :mac => "00:1c:25:9e:fe:1b", :release => "debian-7.1-amd64", :ip => "192.168.1.192", :hostname => "watto" }
]


