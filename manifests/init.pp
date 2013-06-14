class logio {

  include nodejs
  include supervisor
  
  user { 'logio':
    ensure => present,
  }
  package { 'log.io':
    ensure => present,
    provider => 'npm',
  }

  file { 'logio-config':
    ensure => present,
    path   => '/home/logio/.log.io/harvester.conf',
    user   => 'logio',
    source => 'puppet:///modules/logio/haverster.conf',
    require => User['logio'], 
  }

  supervisor::service {
    'logio_server':
	  ensure      => present,
	  enable      => true,
      command     => '/usr/bin/log.io-server',
      user        => 'logio',
      require     => [ Package['log.io'], User['logio'] ];
  }

  supervisor::service {
    'logio_client':
	  ensure      => present,
	  enable      => true,
      command     => '/usr/bin/log.io-harvester',
      user        => 'logio',
      require     => [ Package['log.io'], User['logio'], File['logio-config'] ];
  }

}
