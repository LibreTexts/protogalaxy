# @summary Module to install a barebones HA k8s cluster using kubeadm
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
# @param control_plane_nodes
#   A list of all control plane nodes. This is used by the load balancers on each control plane
#   node to know who each other are. Specify this as a list of strings, where each string is
#   "HOSTNAME:IP".
#
# @param k8s_version
#   Version of the kubeadm, kubelet and kubectl packages to install,
#   along with the control plane version. Defaults to 1.18.5.
#
# @param docker_version
#   Version of docker to install. Defaults to 5:19.03.12~3-0~ubuntu-bionic.
#
# @param role
#   A string indicating what this node is supposed to be. Can be 'initial_control'
#   for the first control plane node, 'control' for additional control plane nodes,
#   'worker' for worker nodes, or empty to indicate you don't want to add it to the cluster.
#
# @param network_interface
#   Specify the network interface where the other nodes are reachable.
#   If this is your default interface, you may omit it.
#   This affects keepalived, HAProxy, and the kube-apiserver.
#
# @param keepalived_image
#   Docker image to be used for the keepalived static pod.
#   Defaults to rkevin/keepalived:2.0.20
#
# @param haproxy_image
#   Docker image to be used for the HAProxy static pod.
#   Defaults to haproxy:2.2-alpine
#
# @param upgrading_cluster
#   Boolean to indicate you're doing cluster upgrades.
#   Since cluster upgrades should be done manually, this turns of package pinning for kubelet.
#   kubeadm and kubectl are still enforced, so you can use this module to upgrade all kubeadm versions.
#   See the README in galaxy-control-repo for upgrade documentation.

class protogalaxy (
  String $kubeapi_ip,
  String $discovery_token,
  String $certkey,
  Array[String] $control_plane_nodes,
  String $k8s_version = '1.18.5',
  String $docker_version = '5:19.03.12~3-0~ubuntu-bionic',
  String $role = '',
  Optional[String] $network_interface = undef,
  String $keepalived_image = 'rkevin/keepalived:2.0.20',
  String $haproxy_image = 'haproxy:2.2-alpine',
) {
  case $role {
    'initial_control': { include protogalaxy::role::initial_control }
    'control':         { include protogalaxy::role::control }
    'worker':          { include protogalaxy::role::worker }
    'management':      { include protogalaxy::role::management }
    default:           { }
  }
}

