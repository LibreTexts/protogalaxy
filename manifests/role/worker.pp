# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include protogalaxy::role::worker
class protogalaxy::role::worker {
  contain protogalaxy::disable_swap
  contain protogalaxy::packages
  contain protogalaxy::service
  contain protogalaxy::bootstrap::worker_join
}
