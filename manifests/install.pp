# == Class owncloud::install
#
class owncloud::install {

  if $owncloud::manage_apache {
    class { '::apache':
      mpm_module        => 'prefork',
      purge_configs     => true,
      before            => Package[$owncloud::package_name],
      default_vhost     => false,
      default_ssl_vhost => false,
    }
  }

  if $owncloud::manage_repo {
    case $::operatingsystem {
      'Ubuntu': {
        apt::source { 'owncloud':
          location    => "http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_${::operatingsystemrelease}/",
          release     => '',
          repos       => '/',
          include_src => false,
          key         => 'BA684223',
          key_source  => "http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_${::operatingsystemrelease}/Release.key",
          before      => Package[$owncloud::package_name],
        }
      }
      default: {
        fail("${module_name} unsupported operatingsystem ${::operatingsystem}")
      }
    }
  }

  package { $owncloud::package_name:
    ensure => present,
  }
}
