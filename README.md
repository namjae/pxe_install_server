PXE Installation Environment by Chef Cookbook
==================

Overview
----

Opscode Chef Cookbook for building PXE installation environment.

Supporting Server OS
----

* Debian Gnu/Linux (I tested Squueze.)
* Ubuntu Server 10.04 LTS or Later

Supporting Guest OS
----

* Debian Gnu/Linux 6.0.5 Squeeze
* Ubuntu Server 12.04 LTS

How to use
----

#### install these packages for chef

    % sudo apt-get update
    % sudo apt-get install build-essential zlib1g-dev libssl-dev

#### install rbenv

    % sudo -i
    # cd ~
    # git clone git://github.com/sstephenson/rbenv.git .rbenv
    # echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
    # echo 'eval "$(rbenv init -)"' >> ~/.bashrc

#### install ruby-build

    # mkdir -p ~/.rbenv/plugins
    # cd ~/.rbenv/plugins
    # git clone git://github.com/sstephenson/ruby-build.git

#### install ruby and chef

    # rbenv install 1.9.2-p290
    # rbenv global 1.9.2-p290
    # rbenv rehash
    # gem install chef
    # rbenv rehash

#### git clone this repository and make environment

    # cd ~
    # mkdir chef-repo; cd chef-repo
    # git clone https://github.com/jedipunkz/pxe_install_server.git
    # mkdir ~/chef-repo/.chef
    # cat > ~/chef-repo/.chef/solo.rb <<EOF
    file_cache_path "/tmp/chef-solo"
    cookbook_path ["/home/bob/chef-repo/cookbooks"]
    role_path "/home/bob/role"
    log_level :info
    # cat > ~/chef-repo/.chef/pxe_install_server.json
    {
      "run_list": [
        "recipe[pxe_install_server]"
      ]
    }

#### execute chef with this cookbook

    # chef-solo -c /root/chef-repo/.chef/solo.rb -j /home/root/chef-repo/.chef/pxe_preceed.json 


Author
----

Tomokazu Hirai ( @jedipunkz ).

Known Bugs
----

* unsupport i386 now (2012/09/16)
