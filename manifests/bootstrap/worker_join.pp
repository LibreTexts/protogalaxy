# @summary Class for worker nodes to join the cluster
#
# @param kubeapi_ip
#   The virtual IP that acts as the load balancer for the kube API server
#
# @param discovery_token
#   The token used to join the cluster, must match the regex [a-z0-9]{6}\.[a-z0-9]{16}
#
# @example
#   include protogalaxy::bootstrap::worker_join {
#     kubeapi_ip     => '172.16.10.25',
#     discovery_token => 'galaxy.8f66ffbc65a6d861',
#   }

class protogalaxy::bootstrap::worker_join (
  String $kubeapi_ip = $protogalaxy::kubeapi_ip,
  String $discovery_token = $protogalaxy::discovery_token,
) {
  exec { 'kubeadm join cluster as worker':
    command => join(['/usr/bin/kubeadm join',
      "https://${kubeapi_ip}:6443/",
      "--discovery-token ${discovery_token}",
      '--discovery-token-unsafe-skip-ca-verification'], ' '),
    creates => '/etc/kubernetes/kubelet.conf',
    require => [
      Service['kubelet'],
      Package['kubeadm'],
    ],
  }
}
