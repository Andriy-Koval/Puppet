#
#  ==== Installation of MySQL Server ====
#

class mysql::mysql_server {
  package { 'mariadb-server':
    ensure  => 'installed',
    before => Package['mysql'],
  }

  package { 'mysql':
    ensure  => installed,
    require => Package['mariadb-server'],
  }

  service { 'mariadb':
    ensure  => running,
    enable  => true,
    require => Package['mariadb-server'],
  }
}
