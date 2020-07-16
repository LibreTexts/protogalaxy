# @summary A short summary of the purpose of this class
#
# A description of what this class does
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
