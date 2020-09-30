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
# @param pod_cidr
#   The desired pod CIDR to pass to kubeadm --pod-network-cidr. Defaults to an empty string.
#
# @param service_cidr
#   The desired service CIDR to pass to kubeadm --service-cidr. Defaults to 10.96.0.0/12.
#
# @param k8s_version
#   Version of the kubeadm, kubelet and kubectl packages to install,
#   along with the control plane version. Defaults to 1.18.5.
#
# @param docker_version
#   Version of docker to install. Defaults to 5:19.03.12~3-0~ubuntu-bionic.
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
#
# @param reset_cluster
#   Boolean to include only the manifest for resetting the cluster with kubeadm

class protogalaxy {
  # This class only defines the variables used in the module.
  # To actually use this module, please include one of the protogalaxy::role::* classes

  $kubeapi_ip = lookup('protogalaxy::kubeapi_ip', String, first)
  $discovery_token = lookup('protogalaxy::discovery_token', String, first)
  $certkey = lookup('protogalaxy::certkey', String, first)
  $control_plane_nodes = lookup('protogalaxy::control_plane_nodes', Array[String], first)
  $pod_cidr = lookup('protogalaxy::pod_cidr', String, first)
  $service_cidr = lookup('protogalaxy::service_cidr', String, first, '10.96.0.0/12')
  $k8s_version = lookup('protogalaxy::k8s_version', String, first, '1.19.2')
  $docker_version = lookup('protogalaxy::docker_version', String, first, '5:19.03.13~3-0~ubuntu-bionic')
  $network_interface = lookup('protogalaxy::network_interface', Optional[String], first, undef)
  $keepalived_image = lookup('protogalaxy::keepalived_image', String, first, 'rkevin/keepalived:2.0.20')
  $haproxy_image = lookup('protogalaxy::haproxy_image', String, first, 'haproxy:2.2-alpine')
  $upgrading_cluster = lookup('protogalaxy::upgrading_cluster', Boolean, first, false)
  $reset_cluster = lookup('protogalaxy::reset_cluster', Boolean, first, false)
}
