#
#  ==== Role for installation of Zabbix Server with Apache HTTPD Web Server, MySQL Database for Zabbix Server, Zabbix Agent
#       and Auto registration of active Zabbix Agents ====
#

class roles::server {
  include profiles::zabbix_server
  include profiles::zabbix_database
  include profiles::zabbix_agent
  include profiles::agent_autoregistry
}
