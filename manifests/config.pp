define php5::config(
  $value,
  $target,
  $section = '',
  $setting = '',
  $ensure  = 'present'
) {
  if (!empty($setting)) {
    $use_setting = $setting
  }
  else {
    $use_setting = $name
  }

  ini_setting { "php-config-${target}-${name}":
    ensure  => $ensure,
    section => $section,
    setting => $use_setting,
    value   => $value,
    path    => $target,
  }
}
