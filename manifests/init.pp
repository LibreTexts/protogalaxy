# @summary Main class for protogalaxy related stuff
#
# A description of what this class does
#
# @example
#   include protogalaxy
#
# @param k8s_version
#   Version of the kubeadm, kubelet and kubectl packages to install,
#   along with the control plane version. Defaults to 1.18.5.
#
class protogalaxy (
  String $kubeapi_ip,
  Array[String] $control_plane_nodes,
  String $role = '',
  String $k8s_version = '1.18.5',
  String $docker_version = '5:19.03.12~3-0~ubuntu-bionic',
  Optional[String] $network_interface = undef,
  String $keepalived_image = 'rkevin/keepalived:2.0.20',
  String $haproxy_image = 'haproxy:2.2-alpine',
) {
  case $role {
    'initial_control': { include protogalaxy::role::initial_control }
    'control':         { include protogalaxy::role::control }
    'worker':          { include protogalaxy::role::worker }
    default:           { }
  }
}

