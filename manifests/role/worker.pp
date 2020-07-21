# @summary Class with all the relevant classes for worker nodes to run
#
# @example
#   include protogalaxy::role::worker
class protogalaxy::role::worker {
  contain protogalaxy::disable_swap
  contain protogalaxy::packages
  contain protogalaxy::service
  contain protogalaxy::bootstrap::worker_join
}
