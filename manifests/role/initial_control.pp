# @summary Class with all the relevant classes for the initial control plane node to run
#
# @example
#   include protogalaxy::role::initial_control

class protogalaxy::role::initial_control {
  contain protogalaxy::disable_swap
  contain protogalaxy::packages
  contain protogalaxy::service
  contain protogalaxy::loadbalancer_static_pods
  contain protogalaxy::bootstrap::kubeadm_init
}
