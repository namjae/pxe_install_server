require 'chefspec'

describe 'pxe_install_server::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'pxe_install_server::default' }
  
  it 'stub out data_bag_item' do
    Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
    Chef::Recipe.any_instance.stub(:data_bag_item).with("pxe_targets", "development").and_return({"id" => "development"})
    chef_run.coverge 'pxe_install_server::default'
  end

  %w{ tftpd-hpa dhcp3-server }.each do |package|
    it 'should be installed #{package}' do
      expect(chef_run).to install_package package
    end
  end

  it 'should be setup netboot.tar.gz file' do
    # dir = chef_run.node["pxe_install_server"]["release"]
    #expect(chef_run).to create_remote_file "/tmp/#{node["pxe_install_server"]["release"]}/amd64.netboot.tar.gz"
    #expect(chef_run).to create_remote_file "/tmp/#{dir}/amd64.netboot.tar.gz"
    chef_run.should create_remote_file "/tmp/ubuntu-12.04.amd64.netboot.tar.gz"
  end

  it 'should be executed bash command' do
    expect(chef_run).to execute_bash_script 'tar'
  end

  it 'should be setup dhcpd.conf' do
    expect(chef_run).to create_file '/etc/dhcp/dhcpd.conf'
  end

  it 'should be setup pxelinux.cfg files.' do
    targets = data_bag_item('pxe_targets', "#{node["pxe_install_server"]["data_bag_name"]}")['targets']
    targets.each do |target|
      mac = target['mac'].downcase.gsub(/:/, '-')
      file = node["pxe_install_server"]["tftp_dir"]/pxelinux.cfg/01-"#{mac}"
      expect(chef_run).to create_file file
    end
  end

  # chef_run = ChefSpec::ChefRunner.new do |node|
  #   node["pxe_install_server"]["tftp_dir"] = "/var/lib/tftpboot"
  # end
  # %w{ node["pxe_install_server"]["tftp_dir"]/preseed.ubuntu.cfg node["pxe_install_server"]["tftp_dir"]/preseed.debian.cfg }.each do |preseed|
  %w{ /var/lib/tftpboot/preseed.ubunt.cfg /var/lib/tftpboot/preseed.debian.cfg }.each do |preseed|
    it 'should be setup preseed.cfg' do
      expect(chef_run).to create_file preseed
    end
  end

  %w{ tftpd-hpa isc-dhcp-server }.each do |service|
    it 'should be started services' do
      expect(chef_run).to start_service service
    end
  end

end
