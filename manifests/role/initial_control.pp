# @summary A short summary of the purpose of this class
#
# A description of what this class does
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
