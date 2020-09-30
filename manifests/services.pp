# @summary Class to ensure the docker service and kubelet service are always running
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
  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['docker-ce'],
  }
  service { 'kubelet':
    ensure  => running,
    enable  => true,
    require => [
      Service['docker'],
      $upgrading_cluster ? {
        true  => undef,
        false => Package['kubelet'],
      },
      Class['protogalaxy::disable_swap'],
    ],
  }
}
