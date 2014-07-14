class graphite(
  $admin_password = undef,
  $port           = $graphite::params::port,
  $config_dir     = $graphite::params::config_dir,
  $secret_key     = $graphite::params::secret_key,
) inherits graphite::params {

  validate_string($admin_password)

  class{'graphite::install': } ->
  class{'graphite::config': } ~>
  class{'graphite::service': } ->
  Class['graphite']

}
