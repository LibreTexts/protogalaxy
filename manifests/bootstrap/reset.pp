# @summary Runs kubeadm reset to tear down the cluster
#
# @example
#   include protogalaxy::bootstrap::reset

class protogalaxy::bootstrap::reset {
  exec { 'kubeadm reset':
    command => '/usr/bin/kubeadm reset -f',
    onlyif  => 'test -e /etc/kubernetes/kubelet.conf',
  }
}
