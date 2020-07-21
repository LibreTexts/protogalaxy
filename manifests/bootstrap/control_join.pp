# @summary Class for additional control plane nodes to join the cluster
#
# @param kubeapi_ip
#   The virtual IP that acts as the load balancer for the kube API server
#
# @param discovery_token
#   The token used to join the cluster, must match the regex [a-z0-9]{6}\.[a-z0-9]{16}
#
# @param certkey
#   A 32 byte key used for control plane nodes to fetch the control plane certs
#   Must be a 64 character long hexadecimal string
#
# @example
#   include protogalaxy::bootstrap::control_join {
#     kubeapi_ip     => '172.16.10.25',
#     discovery_token => 'galaxy.8f66ffbc65a6d861',
#     certkey         => '0e1fe290a032cb3c110ffcde37d93e104b4f560544b1207836d88a093d20982f',
#   }

class protogalaxy::bootstrap::control_join (
  String $kubeapi_ip = $protogalaxy::kubeapi_ip,
  String $discovery_token = $protogalaxy::discovery_token,
  String $certkey = $protogalaxy::certkey,
) {
  exec { 'kubeadm join cluster as control plane node':
    command => '/usr/bin/kubeadm join' +
      "https://${kubeapi_ip}:6443/" +
      '--control-plane' +
      "--discovery-token ${discovery_token}" +
      '--discovery-token-unsafe-skip-ca-verification' +
      "--certificate-key ${certkey}",
    creates => '/etc/kubernetes/kubelet.conf',
    require => [
      Service['kubelet'],
      Package['kubeadm'],
      protogalaxy::loadbalancer_static_pods,
    ],
  }
}
