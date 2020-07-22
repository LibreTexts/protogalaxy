# @summary Create the static pods for loadbalancing the kube API server.
#
# @example
#   include protogalaxy::loadbalancer_static_pods

class protogalaxy::loadbalancer_static_pods {
  file { ['/etc/kubernetes', '/etc/kubernetes/manifests']:
    ensure => directory,
    mode   => '0755',
  }
  contain protogalaxy::loadbalancer_static_pods::keepalived
  contain protogalaxy::loadbalancer_static_pods::haproxy
}
