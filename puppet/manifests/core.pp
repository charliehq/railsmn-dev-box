Exec {
      path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
    }

stage { 'preinstall':
    before => Stage['main']
}

class apt_get_update {
    exec { 'update':
        command => 'apt-get -y update'
    }
}

class { 'apt_get_update':
    stage => preinstall
}

package { 
  [ "vim", "git-core", "build-essential", "snmp", "tkmib", "curl", "wget"]:
    ensure => ["installed"]
}