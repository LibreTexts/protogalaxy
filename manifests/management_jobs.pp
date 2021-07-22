# @summary Class to setup cronjobs and systemd services on the management node
#
# @example
#   include protogalaxy::management_jobs.pp

class protogalaxy::management_jobs inherits protogalaxy {
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
      Kmod::Load['br_netfilter'],
      Sysctl::Value['net.ipv4.ip_forward'],
    ],
  }
}
