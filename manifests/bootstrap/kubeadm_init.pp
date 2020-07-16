# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include protogalaxy::bootstrap::kubeadm_init
class protogalaxy::bootstrap::kubeadm_init {
  # TODO impl
  exec { 'kubeadm initialize cluster':
    command => '/usr/bin/kubeadm something something here',
    creates => '/etc/kubernetes/???',
    require => [
      Service['kubelet'],
      Package['kubeadm'],
      protogalaxy::loadbalancer_static_pods,
    ],
  }
}
