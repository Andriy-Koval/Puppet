#
#  ==== Uploading MySQL dumps to MySQL database for Zabbix Server ====
#

define mysql::mysql_files (
  $database,
  $table,
  $field,
  $value,
  $source = [],
) {
  exec { $source:
    path    => ['/bin', '/usr/bin'],
    unless  => "echo `mysql -uroot -e 'use ${database}; select * from ${table} where ${field}=${value};'` | grep ${value}",
    command => "zcat ${source} | mysql -uroot ${database}",
  }
}
