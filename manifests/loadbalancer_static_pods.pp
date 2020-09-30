# @summary Create the static pods for loadbalancing the kube API server.
#
# @example
#   include protogalaxy::loadbalancer_static_pods

class protogalaxy::loadbalancer_static_pods (
  Boolean $is_initial_control = false,
) inherits protogalaxy {
  file { ['/etc/kubernetes', '/etc/kubernetes/manifests']:
    ensure => directory,
    mode   => '0755',
  }
  class {'protogalaxy::loadbalancer_static_pods::keepalived':
    is_primary => $is_initial_control,
  }
  include protogalaxy::loadbalancer_static_pods::haproxy
}
