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

  package { ['whisper', 'carbon', 'graphite-web']:
    ensure   => installed,
    provider => pip,
    require  => Package['python-pip'],
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
