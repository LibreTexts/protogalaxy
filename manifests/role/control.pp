# @summary Class with all the relevant classes for additional control plane nodes to run
#
# @example
#   include protogalaxy::role::control

class protogalaxy::role::control {
  contain protogalaxy::disable_swap
  contain protogalaxy::packages
  contain protogalaxy::service
  contain protogalaxy::loadbalancer_static_pods
  contain protogalaxy::bootstrap::control_join
}
