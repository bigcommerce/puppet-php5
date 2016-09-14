class php5::fpm(
  $version = 'installed',
  $config_source = 'puppet:///modules/php5/php5-fpm.conf',
  $install_default_pool = true,
  $log_directory = '/var/log/php/'
) inherits php5 {
  $sapi = 'fpm'

  package { 'php5-fpm':
    ensure => $version,
    before => Package['php5-common'],
  }

  service { 'php5-fpm':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  exec { 'reload-php5-fpm':
    command     => '/etc/init.d/php5-fpm reload',
    refreshonly => true,
  }

  augeas { 'php.ini/fpm/PHP':
    context => '/files/etc/php5/fpm/php.ini/PHP/',
    changes => $config_changes,
    notify  => Exec['reload-php5-fpm'],
    require => Package['php5-fpm'],
  }

  file { '/etc/php5/fpm/pool.d/':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['php5-fpm'],
  }

  file { "$log_directory":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '1777',
    require => Package['php5-fpm'],
  }

  file { '/etc/logrotate.d/php':
    ensure  => 'present',
    content => template('php5/fpm-logrotate.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }


  file{ '/var/run/php5-fpm':
    ensure => directory,
  }

  file { '/etc/php5/fpm/php5-fpm.conf':
    ensure => 'link',
    target => '/etc/php5/fpm/php-fpm.conf',
  }

  file { '/etc/php5/fpm/php-fpm.conf':
    ensure  => present,
    source  => $config_source,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['php5-fpm'],
    notify  => Exec['reload-php5-fpm'],
  }

  php5::fpm::pool { 'default':
    ensure => $install_default_pool ? {
      true    => 'present',
      default => 'absent',
    },
  }
}
