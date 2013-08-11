PXE Installation Environment by Chef Cookbook
==================

Overview
----

Opscode Chef Cookbook for building PXE installation environment that includes these service.

* TFTP server
* DHCP server
* Preseed config for debian and ubuntu

Boot machines you want to build with PXE network boot. Machine will be built automaticaly.
Now I support Debian Gnu/Linux and Ubuntu with your machine. Please fork it and add target OSs.


Supporting Server OS
----

* Debian Gnu/Linux 7.1
* Ubuntu Server 12.04 LTS

Supporting Target OS
----

* Debian Gnu/Linux 7.1
* Ubuntu Server 12.04 LTS

And maybe, you can add any distro. please fork it. :D

How to use
----

git clone this repository.

    % cd ~/your_chef_repo
    % git clone git://github.com/jedipunkz/pxe_instal_server.git ./cookbooks/pxe_install_server

Upload this cookbook to your chef server.

    % knife cookbook upload -o ./cookbook pxe_install_server

create data bag.

    % knife data create pxe_targets

edit data bag which named 'pxe_targets' and includes target nodes information.

    % ${EDITOR} data_bags/pxe_targets/development.json
    {
      "id": "development",
      "targets": [
        {
          "ip": "10.200.9.203",
          "mac": "00:50:56:01:01:04",
          "release": "ubuntu-12.04-amd64",
          "hostname": "test01"
        },
        {
          "ip": "10.200.9.201",
          "mac": "00:50:56:01:01:03",
          "release": "debian-7.1-amd64",
          "hostname": "test02"
        }
      ]
    }

upload data bag to chef server.

    % knife data bag from file pxe_targets data_bags/pxe_targets/development.json

Bootstrap your node which you want to build for PXE install server with this
cookbook.

    % knife bootstrap <ip_addr> -N <node_name> -r 'recipe[pxe_install_server]' \
      --sudo -x <your_account_name>


Authror
----

Tomokazu HIRAI ( @jedipunkz ).

Known Bugs
----

None
