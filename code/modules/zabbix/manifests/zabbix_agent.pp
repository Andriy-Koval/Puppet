#
#  ==== Installation of Zabbix Agent ====
#

class zabbix::zabbix_agent (
  $server,
  $server_active,
  $host_metadata_item,
) {
  package { 'zabbix-agent':
    ensure => 'latest',
  }

  file { '/etc/zabbix/zabbix_agentd.conf':
    require => Package['zabbix-agent'],
    content => template('zabbix/zabbix_agentd.conf.erb'),
    notify  => Service['zabbix-agent'],
  }

  service { 'zabbix-agent':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['zabbix-agent'],
  }
}
