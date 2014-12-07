class ruby {
    $ar_databases = ['vagrant']
    $as_vagrant   = 'sudo -u vagrant -H bash -l -c'
    $home         = '/home/vagrant'

    package { ['gnupg2', 'nodejs']:
        ensure=> installed
    }

    exec { 'import_key':
        command => "sudo gpg2 --keyserver hkp://keys.gnupg.net --recv-keys --no-permission-warning --homedir /root/.gnupg D39DC0E3",
        require => Package['gnupg2'],
        logoutput => on_failure
    }

    exec { 'install_rvm':
        command => "curl -L https://get.rvm.io |  bash -s stable --rails",
        creates => '/etc/profile.d/rvm.sh',
        require => [Exec['import_key'], Package['curl']],
        timeout => 0, # disable timeout, this command takes quite a while
        logoutput => on_failure
    }

    exec { 'install_puppet_gem': #rvm install seems to screw up the puppet install on the vagrant box... perhaps this is not the best way to do this?
        command => 'gem install puppet',
        require => Exec['install_rvm'],
        logoutput => on_failure,
        unless => "${as_vagrant} 'puppet'"
    }

    exec { 'install_heroku':
        command => 'wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh',
        require => Package['curl'],
        creates => '/usr/bin/heroku',
        logoutput => on_failure
    }
    
    package { 'rake':
        ensure => 'installed',
        provider => 'gem',
        require => Exec['install_rvm']
    }
    
    exec { "create swap file":
        command => "/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024",
        creates => "/var/swap.1",
    }

    exec { "attach swap file":
        command => "/sbin/mkswap /var/swap.1 && /sbin/swapon /var/swap.1",
        require => Exec["create swap file"],
        unless => "/sbin/swapon -s | grep /var/swap.1",
    }

    # exec { 'initialize_rvm':
        # command => '/etc/profile.d/rvm.sh',
        # require => Exec['install_rvm'],
        # logoutput => true
    # }

    # exec { 'install_ruby':
      # command => "${as_vagrant} 'rvm install ruby-2.0.0-p353 --latest-binary --autolibs=enabled && rvm --fuzzy alias create default 2.0.0'",
      # require => Exec['install_rvm'],
      # logoutput => true
    # }

    # exec { "gem install bundler --no-rdoc --no-ri":
      # creates => "${home}/.rvm/bin/bundle",
      # require => Exec['install_ruby'],
      # logoutput => true
    # }

    # exec { 
        # 'install_rails':
      # command => "${as_vagrant} 'gem install rails --no-rdoc --no-ri'",
      # creates => "${home}/.rvm/bin/rails",
      # require => Exec['install_ruby'],
      # logoutput => true
    # }

    # file {
      # "/home/vagrant/.bash_profile":
      # source => "/vagrant/puppet/files/bash_profile",
      # owner => "vagrant", group => "vagrant", mode => 0664;
    # }

    # exec { "${as_vagrant} 'cd open_camp/ && rails server -d'":    require => Exec['install_rails'] }
}