# @summary Runs kubeadm reset to tear down the cluster
#
# @example
#   include protogalaxy::bootstrap::reset

class protogalaxy::bootstrap::reset inherits protogalaxy {
  include protogalaxy::packages
  exec { 'kubeadm reset':
    command  => '/usr/bin/kubeadm reset -f',
    provider => shell,
    onlyif   => 'test -e /etc/kubernetes/kubelet.conf',
    require  => Package['kubeadm'],
  }
}
