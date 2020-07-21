# @summary Class to ensure swap is disabled on the node.
#
# @example
#   include protogalaxy::disable_swap

class protogalaxy::disable_swap {
  exec { 'disable swap':
    command => '/sbin/swapoff -a',
    unless  => "/usr/bin/awk '{ if (NR > 1) exit 1}' /proc/swaps",
  }
}
