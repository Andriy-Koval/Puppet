#
#  ==== Profile for installation of MySQL Server, creation of MySQL database for Zabbix Server and uploading of MySQL dumps ====
#

class profiles::zabbix_database {

  $db_name       = hiera('profiles::zabbix_database::mysql::mysql_database::db_name')
  $user          = hiera('profiles::zabbix_database::mysql::mysql_database::user')
  $password      = hiera('profiles::zabbix_database::mysql::mysql_database::password')
  $database      = hiera('profiles::zabbix_database::mysql::mysql_files::database')
  $source        = hiera('profiles::zabbix_database::mysql::mysql_files::source')
  $table         = hiera('profiles::zabbix_database::mysql::mysql_files::table')
  $field         = hiera('profiles::zabbix_database::mysql::mysql_files::field')
  $value         = hiera('profiles::zabbix_database::mysql::mysql_files::value')


  class { 'mysql::mysql_server':
    before => Mysql::Mysql_database['zabbix'],
  }

  mysql::mysql_database { 'zabbix':
    db_name  => $db_name,
    user     => $user,
    password => $password,
    require  => Class['mysql::mysql_server'],
    notify   => Service['zabbix-server'],
  }

  notice ($source)

  $source.each |$schemas| {
    mysql::mysql_files { $schemas:
      table    => $table,
      field    => $field,
      value    => $value,
      database => $database,
      source   => $schemas,
      notify   => Service['zabbix-server'],
    }

  notice("MySQL dump ${schemas} is uploaded")
  }
}
