class php5::cli(
  $version = 'installed'
) inherits php5 {
  $sapi = 'cli'

  package { 'php5-cli':
    ensure => $version,
    before => Package['php5-common'],
  }

  $cli_config_changes = [
    'set display_errors On',
  ]

  $real_config_changes = concat($config_changes, $cli_config_changes);

  augeas { 'php.ini/cli/PHP':
    context => '/files/etc/php5/cli/php.ini/PHP/',
    changes => $real_config_changes,
    require => Package['php5-cli'],
  }
}
