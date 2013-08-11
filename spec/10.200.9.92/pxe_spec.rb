require 'spec_helper'

describe package('tftpd-hpa') do
  it { should be_installed }
end

describe package('dhcp3-server') do
  it { should be_installed }
end

describe service('tftpd-hpa') do
  it { should be_enabled   }
  it { should be_running   }
end

describe service('isc-dhcp-server') do
  it { should be_enabled   }
  it { should be_running   }
end

describe file('/etc/dhcp/dhcpd.conf') do
  it { should be_file }
  it { should contain "option broadcast-address" }
end

describe file('/var/lib/tftpboot/pxelinux.cfg') do
  it { should be_directory }
end

describe file('/var/lib/tftpboot/preseed.ubuntu.cfg') do
  it { should be_file }
  it { should contain "partman" }
end

describe file('/var/lib/tftpboot/preseed.debian.cfg') do
  it { should be_file }
  it { should contain "partman" }
end
