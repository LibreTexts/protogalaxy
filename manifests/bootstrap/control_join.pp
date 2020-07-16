# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include protogalaxy::bootstrap::control_join
class protogalaxy::bootstrap::control_join {
  # TODO impl
  exec { 'kubeadm join cluster as control plane node':
    command => '/usr/bin/kubeadm something something here',
    creates => '/etc/kubernetes/???',
    require => [
      Service['kubelet'],
      Package['kubeadm'],
      protogalaxy::loadbalancer_static_pods,
    ],
  }
}
