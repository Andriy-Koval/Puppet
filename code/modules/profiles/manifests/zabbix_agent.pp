#
#  ==== Profile for installation of Zabbix Agent ====
#

class profiles::zabbix_agent {

  $server             = hiera('profiles::zabbix_agent::zabbix::zabbix_agent::server')
  $server_active      = hiera('profiles::zabbix_agent::zabbix::zabbix_agent::server_active')
  $host_metadata_item = hiera('profiles::zabbix_agent::zabbix::zabbix_agent::host_metadata_item')

  class { 'zabbix::zabbix_agent':
    server             => $server,
    server_active      => $server_active,
    host_metadata_item => $host_metadata_item,
  }
}
