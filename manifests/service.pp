# @summary Class to ensure the docker service and kubelet service are always running
#
# @param upgrading_cluster
#   If this boolean is true, do not enforce kubelet to be running.
#
# @example
#   include protogalaxy::service

class protogalaxy::service (
  Boolean $upgrading_cluster = $protogalaxy::upgrading_cluster,
){
  contain protogalaxy::packages
  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['docker-ce'],
  }
  unless $upgrading_cluster {
    service { 'kubelet':
      ensure  => running,
      enable  => true,
      require => [
        Service['docker'],
        Package['kubelet'],
        Class['protogalaxy::disable_swap'],
      ],
    }
  }
}
