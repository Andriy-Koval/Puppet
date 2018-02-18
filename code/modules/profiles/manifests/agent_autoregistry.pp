#
#  ==== Profile for creation and runnig of shell script for Auto registration of Zabbix Agents ====
#

class profiles::agent_autoregistry {

  class { 'zabbix::zabbix_script':
    require => Service['zabbix-server'],
  }
}
