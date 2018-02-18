#
#  ==== Profile for installation of Zabbix Server and Apache HTTPD Web Server with configuration files ====
#

class profiles::zabbix_server {

  $baseurl         = hiera('profiles::zabbix_server::zabbix::zabbix_server::baseurl')
  $dbhost          = hiera('profiles::zabbix_server::zabbix::zabbix_server::dbhost')
  $dbname          = hiera('profiles::zabbix_server::zabbix::zabbix_server::dbname')
  $dbuser          = hiera('profiles::zabbix_server::zabbix::zabbix_server::dbuser')
  $dbpassword      = hiera('profiles::zabbix_server::zabbix::zabbix_server::dbpassword')
  $dbtype          = hiera('profiles::zabbix_server::zabbix::zabbix_server::dbtype')
  $dbserver        = hiera('profiles::zabbix_server::zabbix::zabbix_server::dbserver')
  $dbport          = hiera('profiles::zabbix_server::zabbix::zabbix_server::dbport')
  $dbdatabase      = hiera('profiles::zabbix_server::zabbix::zabbix_server::dbdatabase')
  $db_user         = hiera('profiles::zabbix_server::zabbix::zabbix_server::db_user')
  $db_password     = hiera('profiles::zabbix_server::zabbix::zabbix_server::db_password')
  $zbx_server      = hiera('profiles::zabbix_server::zabbix::zabbix_server::zbx_server')
  $zbx_server_port = hiera('profiles::zabbix_server::zabbix::zabbix_server::zbx_server_port')
  $image_format    = hiera('profiles::zabbix_server::zabbix::zabbix_server::image_format')

  class { 'zabbix::zabbix_server':
    baseurl         => $baseurl,
    dbhost          => $dbhost,
    dbname          => $dbname,
    dbuser          => $dbuser,
    dbpassword      => $dbpassword,
    dbtype          => $dbtype,
    dbserver        => $dbserver,
    dbport          => $dbport,
    dbdatabase      => $dbdatabase,
    db_user         => $db_user,
    db_password     => $db_password,
    zbx_server      => $zbx_server,
    zbx_server_port => $zbx_server_port,
    image_format    => $image_format,
    before          => Class['httpd'],
  }

  class { 'httpd':
    require => Class['zabbix::zabbix_server'],
  }

  class { 'zabbix::zabbix_configs':
    notify => Service['httpd'],
  }
}
