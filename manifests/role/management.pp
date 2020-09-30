# @summary Class with all the relevant classes for management nodes
#
# @example
#   include protogalaxy::role::management

class protogalaxy::role::management inherits protogalaxy {
  require class {'protogalaxy::packages':
    is_mgmt => true,
  }
}
