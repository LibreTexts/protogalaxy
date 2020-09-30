# @summary Class with all the relevant classes for additional control plane nodes to run
#
# @example
#   include protogalaxy::role::control

class protogalaxy::role::control (
  Boolean $reset_cluster = $protogalaxy::reset_cluster,
) inherits protogalaxy {
  require protogalaxy::disable_swap
  require protogalaxy::packages
  if $reset_cluster {
    require protogalaxy::bootstrap::reset
  } else {
    require protogalaxy::services
    require class {'protogalaxy::loadbalancer_static_pods':
      is_initial_control => false,
    }
    require protogalaxy::bootstrap::control_join
  }
}
