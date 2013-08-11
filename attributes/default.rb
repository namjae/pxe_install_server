# Cookbook Name:: pxe_install_server
# Attributes:: default
#
# Author:: Tomokazu Hirai ( @jedipunkz )

# dhcpd.conf parameters
default['pxe_install_server']['pxeserver_service_host'] = "10.200.9.92"
default['pxe_install_server']['pxeserver_address'] = "10.200.9.0"
default['pxe_install_server']['pxeserver_netmask'] = "255.255.255.0"
default['pxe_install_server']['pxeserver_broadcast'] = "10.200.9.255"
default['pxe_install_server']['pxeserver_range_min'] = "10.200.9.200"
default['pxe_install_server']['pxeserver_range_max'] = "10.200.9.209"
default['pxe_install_server']['pxeserver_router'] = "10.200.9.1"
default['pxe_install_server']['pxeserver_nameserver'] = "8.8.8.8"

# tftpd paramater
case node['platform']
when 'debian'
  default['pxe_install_server']['tftp_dir'] = "/srv/tftp"
when 'ubuntu'
  default['pxe_install_server']['tftp_dir'] = "/var/lib/tftpboot"
end

# data_bag name for the information of target nodes
default['pxe_install_server']['data_bag_name'] = "development"

# distro list : please set netboot.tar.gz URL
default['pxe_install_server']['releases'] = [
    { :dist => "ubuntu-12.04-amd64", :path => "http://archive.ubuntu.com/ubuntu/dists/precise/main/installer-amd64/current/images/netboot/netboot.tar.gz" },
    { :dist => "ubuntu-12.04-i386", :path => "http://archive.ubuntu.com/ubuntu/dists/precise/main/installer-i386/current/images/netboot/netboot.tar.gz" },
    { :dist => "debian-7.1-amd64", :path => "http://ftp.debian.org/debian/dists/wheezy/main/installer-amd64/current/images/netboot/netboot.tar.gz" },
    { :dist => "debian-7.1-i386", :path => "http://ftp.debian.org/debian/dists/wheezy/main/installer-i386/current/images/netboot/netboot.tar.gz" }
]
