#
#  ==== Shell script for Auto registration of Zabbix Agents ====
#

class zabbix::zabbix_script (
  $agents_autoreg = true,
) {
  file { 'zabbix_script.sh':
    ensure => 'file',
    source => 'puppet:///modules/zabbix/zabbix_script.sh',
    path   => '/etc/zabbix/zabbix_script.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0744',
    notify => Exec['zabbix_script'],
  }

  if $agents_autoreg {
    exec { 'zabbix_script':
      command     => '/etc/zabbix/zabbix_script.sh',
      refreshonly => true,
      require     => File['zabbix_script.sh'],
    }
  }
}
