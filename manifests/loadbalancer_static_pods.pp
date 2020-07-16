# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include protogalaxy::loadbalancer_static_pods
class protogalaxy::loadbalancer_static_pods {
  contain protogalaxy::loadbalancer_static_pods::keepalived
  contain protogalaxy::loadbalancer_static_pods::haproxy
}
