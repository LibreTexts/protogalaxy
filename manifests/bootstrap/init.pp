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
#   include protogalaxy::bootstrap::init {
#     kubeapi_ip      => '172.16.10.25',
#     discovery_token => 'galaxy.8f66ffbc65a6d861',
#     certkey         => '0e1fe290a032cb3c110ffcde37d93e104b4f560544b1207836d88a093d20982f',
#   }

class protogalaxy::bootstrap::init (
  String $kubeapi_ip = $protogalaxy::kubeapi_ip,
  String $discovery_token = $protogalaxy::discovery_token,
  String $certkey = $protogalaxy::certkey,
  String $pod_cidr = $protogalaxy::pod_cidr,
  String $service_cidr = $protogalaxy::service_cidr,
) inherits protogalaxy {
  include protogalaxy::services
  include protogalaxy::packages
  include protogalaxy::loadbalancer_static_pods
  exec { 'kubeadm initialize cluster':
    command => join(['/usr/bin/kubeadm init',
      "--control-plane-endpoint ${kubeapi_ip}:6443",
      '--upload-certs',
      "--token ${discovery_token}",
      "--certificate-key ${certkey}",
      '--apiserver-bind-port 16443',
      "--pod-network-cidr ${pod_cidr}",
      "--service-cidr ${service_cidr}"], ' '),
    creates => '/etc/kubernetes/kubelet.conf',
    require => [
      Service['kubelet'],
      Package['kubeadm'],
      Class['protogalaxy::loadbalancer_static_pods'],
    ],
  }
}
