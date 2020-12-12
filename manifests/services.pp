# @summary Class to ensure the containerd service and kubelet service are always running
#
# @param upgrading_cluster
#   If this boolean is true, do not enforce kubelet to be running.
#
# @example
#   include protogalaxy::services

class protogalaxy::services (
  Boolean $upgrading_cluster = $protogalaxy::upgrading_cluster,
) inherits protogalaxy {
  include protogalaxy::packages
  require protogalaxy::disable_swap

  kmod::load { 'br_netfilter':
    ensure => present,
  }

  sysctl::value { 'net.ipv4.forward':
    value => 1,
  }

  service { 'containerd':
    ensure  => running,
    enable  => true,
    require => Package['containerd.io'],
  }
  service { 'kubelet':
    ensure  => running,
    enable  => true,
    require => [
      Service['containerd'],
      $upgrading_cluster ? {
        true  => undef,
        false => Package['kubelet'],
      },
      Class['protogalaxy::disable_swap'],
      Class['kmod::load::br_netfilter'],
      Class['sysctl::value::net.ipv4.forward'],
    ],
  }
}
