# @summary A short summary of the purpose of this class
#
# @example
#   include protogalaxy::cluster_reset

class protogalaxy::cluster_reset {
  exec { 'kubeadm reset':
    command => '/usr/bin/kubeadm reset -f',
    onlyif => 'test -e /etc/kubernetes/kubelet.conf',
  }
}
