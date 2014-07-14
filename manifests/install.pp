class graphite::install {

  ensure_packages([
    'python-cairo',
    'python-django',
    'python-django-tagging',
    'python-ldap',
    'python-memcache',
    'python-pip',
    'python-pysqlite2',
    'python-simplejson',
    'python-support',
    'python-twisted',
  ])

  Package['python-pip'] -> Package <| provider == 'pip' and ensure != absent and ensure != purged |>

#  package { ['whisper', 'carbon', 'graphite-web']:
  package { ['whisper']:
    ensure   => 'installed',
    provider => pip,
    require  => Package['python-pip'],
  }

  #Carbon and Graphite-Web need to be installed to a custom location.
  exec { 'pip-install-carbon':
    command     => '/usr/bin/pip install carbon',
    environment => 'PYTHONPATH=/opt/graphite/lib:/opt/graphite/webapp',
    unless      => '/usr/bin/pip list | /bin/grep carbon',
  }
  exec { 'pip-install-graphite-web':
    command     => '/usr/bin/pip install graphite-web',
    environment => 'PYTHONPATH=/opt/graphite/lib:/opt/graphite/webapp',
    unless      => '/usr/bin/pip list | /bin/grep graphite-web',
  }

  file { '/var/log/carbon':
    ensure => directory,
    owner  => www-data,
    group  => www-data,
  }

  file {'/var/lib/graphite':
    ensure => directory,
    owner  => www-data,
    group  => www-data,
  }

  file {'/var/lib/graphite/db.sqlite3':
    ensure => present,
    owner  => www-data,
    group  => www-data,
  }

}
