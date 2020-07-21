# @summary Class to ensure the docker service and kubelet service are always running
#
# @example
#   include protogalaxy::service

class protogalaxy::service {
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
      Package['kubelet'],
      protogalaxy::disable_swap,
    ],
  }
}
