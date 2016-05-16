define php5::fpm::pool(
  $prefix           = '',
  $listen           = '127.0.0.1',
  $port             = '9000',
  $user             = 'www-data',
  $group            = 'www-data',
  $mode             = '0666',
  $pm               = 'dynamic',
  $pm_max_children  = 50,
  $pm_start_servers = 20,
  $pm_min_spare     = 5,
  $pm_max_spare     = 35,
  $pm_max_requests  = 0,
  $env              = [],
  $php_values       = [],
  $php_admin_values = [],
  $access_log_file  = '',
  $access_format    = '',
  $misc_options     = [],
  $ensure           = 'present',
  $status_path      = '/fpm-status',
  $ping_path        = '/fpm-ping'
) {

  file { "/etc/php5/fpm/pool.d/${name}.conf":
    content   => template('php5/fpm-pool.conf.erb'),
    owner     => root,
    group     => root,
    mode      => 0644,
    require   => File['/etc/php5/fpm/pool.d/'],
    notify    => Exec['reload-php5-fpm'],
    ensure    => $ensure,
  }
}
