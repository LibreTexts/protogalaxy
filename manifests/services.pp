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

  sysctl::value { 'net.ipv4.ip_forward':
    value => 1,
  }

  exec { 'ensure containerd does not disable cri':
    command => 'rm /etc/containerd/config.toml',
    onlyif  => 'grep \'disabled_plugins = \["cri"\]\' /etc/containerd/config.toml',
  }

  service { 'containerd':
    ensure  => running,
    enable  => true,
    require => [
      Package['containerd.io'],
      Exec['ensure containerd does not disable cri'],
    ]
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
      Kmod::Load['br_netfilter'],
      Sysctl::Value['net.ipv4.ip_forward'],
    ],
  }
}
