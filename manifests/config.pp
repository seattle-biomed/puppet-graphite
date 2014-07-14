# Graphite Configuration
class graphite::config {

  $config_dir     = $graphite::config_dir
  $admin_password = $graphite::admin_password
  $port           = $graphite::port
  $secret_key     = $graphite::secret_key

  file { '/etc/init.d/carbon':
    ensure => link,
    target => '/lib/init/upstart-job',
  }

  file { '/etc/init/carbon.conf':
    ensure => present,
    source => 'puppet:///modules/graphite/carbon.conf',
    mode   => '0555',
  }

  file { "${config_dir}/conf/carbon.conf":
    ensure    => present,
    content   => template('graphite/carbon.conf.erb'),
  }

  file { "${config_dir}/conf/storage-schemas.conf":
    ensure    => present,
    source    => 'puppet:///modules/graphite/storage-schemas.conf',
  }

  file { ["${config_dir}/storage", "${config_dir}/storage/whisper"]:
    owner     => 'www-data',
    mode      => '0775',
  }

  exec { 'init-graphite-db':
    command   => '/usr/bin/python manage.py syncdb --noinput',
    cwd       => "${config_dir}/webapp/graphite",
    creates   => "${config_dir}/storage/graphite.db",
    subscribe => File["${config_dir}/storage"],
    require   => [File["${config_dir}/webapp/graphite/initial_data.json"], File["${config_dir}/webapp/graphite/local_settings.py"]],
  }

  file { "${config_dir}/webapp/graphite/initial_data.json":
    ensure  => present,
    require => File["${config_dir}/storage"],
    content => template('graphite/initial_data.json.erb'),
  }

  file { "${config_dir}/storage/graphite.db":
    owner     => 'www-data',
    mode      => '0664',
    subscribe => Exec['init-graphite-db'],
  }

  file { "${config_dir}/storage/log/webapp/":
    ensure    => 'directory',
    owner     => 'www-data',
#    subscribe => Package['graphite-web'],
    subscribe => Exec['pip-install-graphite-web'],
  }

  file { "${config_dir}/webapp/graphite/local_settings.py":
    ensure  => present,
    owner     => 'www-data',
    mode      => '0550',
    content => template('graphite/local_settings.py.erb'),
    require => File["${config_dir}/storage"]
  }

}
