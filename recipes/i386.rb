# Cookbook Name:: pxe_install_server
# Author:: Tomokazu Hirai ( @jedipunkz )
#
# Recipe:: default
#

package "tftpd-hpa"
package "dhcp3-server"

node[:pxe_install_server][:releases].each do |release, path|
  case node['platform']
  when 'debian'
    remote_file "/tmp/#{release}.netboot.tar.gz" do
      source "http://archive.ubuntu.com/ubuntu/dists/#{path}/main/installer-i386/current/images/netboot/netboot.tar.gz"
      not_if { File.exists?("/srv/tftp/#{release}") || File.exists?("/tmp/#{release}.netboot.tar.gz") }
    end
  when 'ubuntu'
    remote_file "/tmp/#{release}.netboot.tar.gz" do
      source "http://archive.ubuntu.com/ubuntu/dists/#{path}/main/installer-i386/current/images/netboot/netboot.tar.gz"
      not_if { File.exists?("/var/lib/tftpboot/#{release}") || File.exists?("/tmp/#{release}.netboot.tar.gz") }
    end
  end


  script "copy netboot files" do
    interpreter "bash"
    user "root"

    case node['platform']
    when 'debian'
      code <<-EOH
      tar zxvf /tmp/#{release}.netboot.tar.gz -C /srv/tftp/
      EOH
    when 'ubuntu'
      code <<-EOH
      tar zxvf /tmp/#{release}.netboot.tar.gz -C /var/lib/tftpboot/
      EOH
    end
  end

end

service "networking" do
  supports :restart => true
end

service "isc-dhcp-server"  do
  supports :restart => true
end

service "tftpd-hpa"  do
  supports :restart => true
end

case node['platform']
when 'debian'
  template "/etc/dhcp3/dhcpd.conf" do
    source "dhcpd.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables({ :servers => node[:pxe_install_server][:servers] })
    notifies :restart, resources(:service => "isc-dhcp-server")
  end
when 'ubuntu'
  template "/etc/dhcp/dhcpd.conf" do
    source "dhcpd.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables({ :servers => node[:pxe_install_server][:servers] })
    notifies :restart, resources(:service => "isc-dhcp-server")
  end
end

node[:pxe_install_server][:servers].each do |server|
  mac = server[:mac].downcase.gsub(/:/, '-')
  case node['platform']
  when 'debian'
    template "/srv/tftp/pxelinux.cfg/01-#{mac}" do
      source "pxelinux.i386.erb"
      mode 0644
      variables({
        :mac => mac,
        :release => server[:release]
      })
      notifies :restart, resources(:service => "tftpd-hpa"), :delayed
    end
  when 'ubuntu'
    template "/var/lib/tftpboot/pxelinux.cfg/01-#{mac}" do
      source "pxelinux.i386.erb"
      mode 0644
      variables({
        :mac => mac,
        :release => server[:release]
      })
      notifies :restart, resources(:service => "tftpd-hpa"), :delayed
    end
  end
end

case node['platform']
when 'debian'
  template "/srv/tftp/preseed.cfg" do
    source "preseed.debian.cfg.erb"
    mode 0644
  end
when 'ubuntu'
  template "/var/lib/tftpboot/preseed.cfg" do
    source "preseed.ubuntu.cfg.erb"
    mode 0644
  end
end
