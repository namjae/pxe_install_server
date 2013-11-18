# Cookbook Name:: pxe_install_server
# Author:: Tomokazu Hirai ( @jedipunkz )
#
# Recipe:: default
#

execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

package "tftpd-hpa"
package "dhcp3-server"

node['pxe_install_server']['releases'].each do |release|
  dist = release[:dist]
  path = release[:path]
  remote_file "#{Chef::Config[:file_cache_path]}/#{dist}.amd64.netboot.tar.gz" do
    source path
    not_if { File.exists?("#{node["pxe_install_server"]["tftp_dir"]}/#{dist}") || File.exists?("/tmp/#{dist}.amd64.netboot.tar.gz") }
  end

  script "copy netboot files" do
    interpreter "bash"
    user "root"
    code <<-EOH
    tar zxvf /#{Chef::Config[:file_cache_path]}/#{dist}.amd64.netboot.tar.gz -C #{node["pxe_install_server"]["tftp_dir"]}
    EOH
  end
end

targets = data_bag_item('pxe_targets', node["pxe_install_server"]["data_bag_name"])['targets']

template "/etc/dhcp/dhcpd.conf" do
  source "dhcpd.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables :targets => targets
  notifies(:restart, "service[isc-dhcp-server]")
end

targets.each do |target|
  mac = target['mac'].downcase.gsub(/:/, '-')
  template "#{node["pxe_install_server"]["tftp_dir"]}/pxelinux.cfg/01-#{mac}" do
    source "pxelinux.#{target['release']}.erb"
    mode 0644
    variables({
      :mac => mac,
      :release => target['release']
    })
    notifies(:restart, "service[tftpd-hpa]")
  end

  if target["release"].include?("ubuntu")
    template "#{node["pxe_install_server"]["tftp_dir"]}/preseed.ubuntu.cfg" do
      source "preseed.ubuntu.cfg.erb"
      mode 0644
      variables({
        :fullname => target['user-fullname'],
        :username => target['username'],
        :passwd   => target['user-password-crypted']
      })
    end
  end

  if target["release"].include?("debian")
    template "#{node["pxe_install_server"]["tftp_dir"]}/preseed.debian.cfg" do
      source "preseed.ubuntu.cfg.erb"
      mode 0644
      variables({
        :fullname => target['user-fullname'],
        :username => target['username'],
        :passwd   => target['user-password-crypted']
      })
    end
  end
end

# script "symlink to each pxelinux" do
  # interpreter "bash"
  # user "root"
  # code <<-EOH
  # cd "#{node["pxe_install_server"]["tftp_dir"]}"

node["pxe_install_server"]["releases"].each do |release|
  dist = release[:dist]
  if dist.include?("ubuntu")
    script "symlink to each pxelinux" do
      interpreter "bash"
      user "root"
      code <<-EOH
      cd "#{node["pxe_install_server"]["tftp_dir"]}"
      ln -sf ubuntu-installer/amd64/pxelinux.0 pxelinux.0-"#{dist}"
      EOH
    end
  end
  if dist.include?("debian")
    script "symlink to each pxelinux" do
      interpreter "bash"
      user "root"
      code <<-EOH
      cd "#{node["pxe_install_server"]["tftp_dir"]}"
      ln -sf debian-installer/amd64/pxelinux.0 pxelinux.0-"#{dist}"
      EOH
    end
  end
end
  # ln -sf ubuntu-installer/amd64/pxelinux.0 pxelinux.0-ubuntu-12.04-amd64
  # ln -sf ubuntu-installer/i386/pxelinux.0 pxelinux.0-ubuntu-12.04-i386
  # ln -sf debian-installer/amd64/pxelinux.0 pxelinux.0-debian-7.1-amd64
  # ln -sf debian-installer/i386/pxelinux.0 pxelinux.0-debian-7.1-i386
  #EOH
#end

service "tftpd-hpa" do
  supports :restart => true
  action :start
end

service "isc-dhcp-server" do
  supports :restart => true
  action :start
end
