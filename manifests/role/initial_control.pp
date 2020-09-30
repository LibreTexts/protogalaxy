# @summary Class with all the relevant classes for the initial control plane node to run
#
# @example
#   include protogalaxy::role::initial_control

class protogalaxy::role::initial_control {
  contain protogalaxy::disable_swap
  contain protogalaxy::packages
  if ($protogalaxy::reset_cluster) {
    contain protogalaxy::bootstrap::reset
  } else {
    contain protogalaxy::service
    contain protogalaxy::loadbalancer_static_pods
    contain protogalaxy::bootstrap::kubeadm_init
  }
}
