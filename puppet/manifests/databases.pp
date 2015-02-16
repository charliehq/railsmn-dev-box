class mysql {
    package {
        ["mysql-client", "mysql-server", "libmysqlclient-dev"]: 
            ensure => installed, 
            require => Exec['apt-update']
    }

    service { "mysql":
        ensure    => running,
        enable    => true,
        require => Package["mysql-server"],  
    }
}

class redis {
    package {
        ["redis-server"]: 
            ensure => installed,
    }
    
    service { "redis-server":
        ensure    => running,
        enable    => true,
        require => Package["redis-server"],  
    }
}

class postgresql {
    package {
        ["postgresql", "postgresql-client", "libpq-dev"]: 
            ensure => installed,
    }
    service { "postgresql":
        ensure    => running,
        enable    => true,
        require => Package["postgresql"],  
    }
}

class mongodb {
    package { 'mongodb':
        ensure => present,
    }

    service { 'mongodb':
        ensure  => running,
        require => Package['mongodb'],
    }
    
    exec { 'allow remote mongo connections':
        command => "/usr/bin/sudo sed -i 's/bind_ip = 127.0.0.1/bind_ip = 0.0.0.0/g' /etc/mongodb.conf",
        notify  => Service['mongodb'],
        onlyif  => '/bin/grep -qx  "bind_ip = 127.0.0.1" /etc/mongodb.conf',
    }
}



