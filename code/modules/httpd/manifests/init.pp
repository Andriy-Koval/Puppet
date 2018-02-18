#
#  ==== Installation of Apache HTTPD Server with TLS certificates ====
#

class httpd (
  $https           = true,
  $listen          = ['80'],
  $namevirtualhost = [],
  $servername      = undef,
  $httpd_version   = 'latest',
  $service_restart = '/sbin/service httpd reload',
) {
  package { 'httpd':
    ensure => $httpd_version,
  }

  file { '/etc/httpd/conf/httpd.conf':
    require => Package['httpd'],
    content => template('httpd/httpd.conf.erb'),
    notify  => Service['httpd'],
  }

  service { 'httpd':
    ensure    => running,
    enable    => true,
    restart   => $service_restart,
    hasstatus => true,
    require   => Package['httpd'],
  }

  if $https {
    package { 'mod_ssl':
      ensure => installed,
      notify => Service['httpd'],
    }

    package { 'openssl':
      ensure => 'installed',
    }

    file { '/etc/pki/tls/certs/devops.crt':
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/httpd/devops.crt',
      before => File['/etc/pki/tls/private/devops.key'],
    }

    file { '/etc/pki/tls/private/devops.key':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/httpd/devops.key',
      require => File['/etc/pki/tls/certs/devops.crt'],
    }

    file { '/etc/pki/tls/private/devops.csr':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/httpd/devops.csr',
      require => File['/etc/pki/tls/private/devops.key'],
      notify  => Service['httpd'],
    }
  }
}
