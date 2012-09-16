# Cookbook Name:: pxe_install_server
# Author:: Tomokazu Hirai ( @jedipunkz )
#
# Recipe:: default
#

package "tftpd-hpa"
package "dhcp3-server"

node[:pxe_install_server][:releases].each do |release|
  dist = release[:dist]
  path = release[:path]
  case node['platform']
  when 'debian'
    remote_file "/tmp/#{dist}.amd64.netboot.tar.gz" do
      source "#{path}"
      not_if { File.exists?("/srv/tftp/#{dist}") || File.exists?("/tmp/#{dist}.amd64.netboot.tar.gz") }
    end
  when 'ubuntu'
    remote_file "/tmp/#{dist}.amd64.netboot.tar.gz" do
      source "#{path}"
      not_if { File.exists?("/var/lib/tftpboot/#{dist}") || File.exists?("/tmp/#{dist}.amd64.netboot.tar.gz") }
    end
  end


  script "copy netboot files" do
    interpreter "bash"
    user "root"

    case node['platform']
    when 'debian'
      code <<-EOH
      tar zxvf /tmp/#{dist}.amd64.netboot.tar.gz -C /srv/tftp/
      EOH
    when 'ubuntu'
      code <<-EOH
      tar zxvf /tmp/#{dist}.amd64.netboot.tar.gz -C /var/lib/tftpboot/
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
    case server[:release]
    when 'ubuntu-12.04'
      template "/srv/tftp/pxelinux.cfg/01-#{mac}" do # It looks for 01-#{mac} for some reason.
        source "pxelinux.ubuntu.erb"
        mode 0644
        variables({
          :mac => mac,
          :release => server[:release]
        })
        notifies :restart, resources(:service => "tftpd-hpa"), :delayed
      end
    when 'debian-6.0.5'
      template "/srv/tftp/pxelinux.cfg/01-#{mac}" do # It looks for 01-#{mac} for some reason.
        source "pxelinux.debian.erb"
        mode 0644
        variables({
          :mac => mac,
          :release => server[:release]
        })
        notifies :restart, resources(:service => "tftpd-hpa"), :delayed
      end
    end
  when 'ubuntu'
    case server[:release]
    when 'ubuntu-12.04'
      template "/var/lib/tftpboot/pxelinux.cfg/01-#{mac}" do # It looks for 01-#{mac} for some reason.
        source "pxelinux.ubuntu.erb"
        mode 0644
        variables({
          :mac => mac,
          :release => server[:release]
        })
        notifies :restart, resources(:service => "tftpd-hpa"), :delayed
      end
    when 'debian-6.0.5'
      template "/var/lib/tftpboot/pxelinux.cfg/01-#{mac}" do # It looks for 01-#{mac} for some reason.
        source "pxelinux.debian.erb"
        mode 0644
        variables({
          :mac => mac,
          :release => server[:release]
        })
        notifies :restart, resources(:service => "tftpd-hpa"), :delayed
      end
    end
  end
end

case node['platform']
when 'debian'
  template "/srv/tftp/preseed.ubuntu.cfg" do
    source "preseed.ubuntu.cfg.erb"
    mode 0644
  end
  template "/srv/tftp/preseed.debian.cfg" do
    source "preseed.debian.cfg.erb"
    mode 0644
  end
when 'ubuntu'
  template "/var/lib/tftpboot/preseed.ubuntu.cfg" do
    source "preseed.ubuntu.cfg.erb"
    mode 0644
  end
  template "/var/lib/tftpboot/preseed.debian.cfg" do
    source "preseed.debian.cfg.erb"
    mode 0644
  end
end
