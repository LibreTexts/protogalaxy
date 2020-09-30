# @summary Class with all the relevant classes for worker nodes to run
#
# @example
#   include protogalaxy::role::worker

class protogalaxy::role::worker (
  Boolean $reset_cluster = $protogalaxy::reset_cluster,
) inherits protogalaxy {
  require protogalaxy::disable_swap
  require protogalaxy::packages
  if $reset_cluster {
    require protogalaxy::bootstrap::reset
  } else {
    require protogalaxy::services
    require protogalaxy::bootstrap::worker_join
  }
}
