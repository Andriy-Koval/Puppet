#
#  ==== Installation of Zabbix Server ====
#

class zabbix::zabbix_server (
  $baseurl,
  $dbhost,
  $dbname,
  $dbuser,
  $dbpassword,
  $dbtype,
  $dbserver,
  $dbport,
  $dbdatabase,
  $db_user,
  $db_password,
  $zbx_server,
  $zbx_server_port,
  $image_format,
  $dbschema        = undef,
  $zbx_server_name = undef,
) {
  yumrepo { 'zabbix':
    enabled  => 1,
    descr    => 'Zabbix Official Repository - $basearch',
    baseurl  => $baseurl,
    gpgcheck => 0,
    before   => Package['zabbix-server'],
  }

  package { 'zabbix-server':
    ensure  => 'installed',
    require => Yumrepo['zabbix'],
  }

  package { 'zabbix-server-mysql':
    ensure  => 'installed',
    require => Package['zabbix-server'],
  }

  package { 'zabbix-web-mysql':
    ensure  => 'installed',
    require => Package['zabbix-server-mysql'],
  }

  file { '/etc/zabbix/zabbix_server.conf':
    require => Package['zabbix-server'],
    content => template('zabbix/zabbix_server.conf.erb'),
    notify  => Service['zabbix-server'],
  }

  file { '/etc/zabbix/web/zabbix.conf.php':
    require => Package['zabbix-server'],
    content => template('zabbix/zabbix.conf.php.erb'),
    notify  => Service['zabbix-server'],
  }

  service { 'zabbix-server':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['zabbix-server'],
  }
}
