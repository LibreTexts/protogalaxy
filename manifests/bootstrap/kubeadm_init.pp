# @summary Class for initializing the first control plane node of the cluster
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
#   include protogalaxy::bootstrap::kubeadm_init {
#     kubeapi_ip      => '172.16.10.25',
#     discovery_token => 'galaxy.8f66ffbc65a6d861',
#     certkey         => '0e1fe290a032cb3c110ffcde37d93e104b4f560544b1207836d88a093d20982f',
#   }

class protogalaxy::bootstrap::kubeadm_init (
  String $kubeapi_ip = $protogalaxy::kubeapi_ip,
  String $discovery_token = $protogalaxy::discovery_token,
  String $certkey = $protogalaxy::certkey,
) {
  exec { 'kubeadm initialize cluster':
    command => join(['/usr/bin/kubeadm init',
      "--control-plane-endpoint https://${kubeapi_ip}:6443/",
      '--upload-certs',
      "--token ${discovery_token}",
      "--certificate-key ${certkey}"], ' '),
    creates => '/etc/kubernetes/kubelet.conf',
    require => [
      Service['kubelet'],
      Package['kubeadm'],
      Class['protogalaxy::loadbalancer_static_pods'],
    ],
  }
}
