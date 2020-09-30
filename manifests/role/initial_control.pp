# @summary Class with all the relevant classes for the initial control plane node to run
#
# @example
#   include protogalaxy::role::initial_control

class protogalaxy::role::initial_control (
  Boolean $reset_cluster = $protogalaxy::reset_cluster,
) inherits protogalaxy {
  require protogalaxy::disable_swap
  require protogalaxy::packages
  if $reset_cluster {
    require protogalaxy::bootstrap::reset
  } else {
    require protogalaxy::services
    require class {'protogalaxy::loadbalancer_static_pods':
      is_initial_control => true,
    }
    require protogalaxy::bootstrap::init
  }
}
