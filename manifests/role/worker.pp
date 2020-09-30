# @summary Class with all the relevant classes for worker nodes to run
#
# @example
#   include protogalaxy::role::worker
class protogalaxy::role::worker {
  contain protogalaxy::disable_swap
  contain protogalaxy::packages
  if ($protogalaxy::reset_cluster) {
    contain protogalaxy::bootstrap::reset
  } else {
    contain protogalaxy::service
    contain protogalaxy::bootstrap::worker_join
  }
}
