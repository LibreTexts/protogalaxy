# @summary Create the static pods for loadbalancing the kube API server.
#
# @example
#   include protogalaxy::loadbalancer_static_pods

class protogalaxy::loadbalancer_static_pods {
  contain protogalaxy::loadbalancer_static_pods::keepalived
  contain protogalaxy::loadbalancer_static_pods::haproxy
}
