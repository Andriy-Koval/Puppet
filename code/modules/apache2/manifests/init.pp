#
#  ==== Installation of Apache2 Web Server with TLS certificates ====
#

class apache2 (
  $apache2_version         = 'latest',
  $timeout                 = undef,
  $keep_alive              = undef,
  $max_keep_alive_requests = undef,
  $keep_alive_timeout      = undef,
  $log_level               = ['warn']
  $listen_port             = ['80','8080']
  $https                   = true,
  $service_restart         = '/sbin/service apache2 reload',
) {
  package { 'apache2':
    ensure => $apache2_version,
  }

  file { '/etc/apache2/apache2.conf':
    require => Package['apache2'],
    content => template('apache2/apache2.conf.erb'),
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/ports.conf':
    require => Package['apache2'],
    content => template('apache2/ports.conf.erb'),
    notify  => Service['apache2'],
  }

  service { 'apache2':
    ensure    => running,
    enable    => true,
    restart   => $service_restart,
    hasstatus => true,
    require   => Package['apache2'],
  }

  if $https {
    package { 'mod_ssl':
      ensure => installed,
      notify => Service['apache2'],
    }

    package { 'openssl':
      ensure => 'installed',
    }

    file { '/etc/pki/tls/certs/devops.crt':
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/apache2/devops.crt',
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
