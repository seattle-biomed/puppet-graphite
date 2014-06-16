class graphite(
  $admin_password = undef,
  $port           = $graphite::params::port,
  $config_dir     = $graphite::params::config_dir,
) inherits graphite::params {

  validate_string($admin_password)

  class{'graphite::install': } ->
  class{'graphite::config': } ~>
  class{'graphite::service': } ->
  Class['graphite']

}
