# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include protogalaxy::bootstrap::worker_join
class protogalaxy::bootstrap::worker_join {
  # TODO impl
  exec { 'kubeadm join cluster as worker':
    command => '/usr/bin/kubeadm something something here',
    creates => '/etc/kubernetes/???',
    require => [
      Service['kubelet'],
      Package['kubeadm'],
    ],
  }
}
