# @summary Create HAProxy static pod
#
# Create the HAProxy static pod by placing its yaml in /etc/kubernetes/manifests
# and its relevant config file in /etc/kubernetes/haproxy.cfg.
# This will serve as the load balancer for the kube API server.
# This should be created on all control plane nodes.
#
# @example
#   include protogalaxy::loadbalancer_static_pods::haproxy

class protogalaxy::loadbalancer_static_pods::haproxy (
  String $vip = $protogalaxy::kubeapi_ip,
  Array[String] $control_plane_nodes = $protogalaxy::control_plane_nodes,
  String $haproxy_image = $protogalaxy::haproxy_image,
  Optional[String] $_interface = $protogalaxy::network_interface,
) inherits protogalaxy {
  include protogalaxy::services
  $interface = pick($_interface, $facts['networking']['primary'])
  file { '/etc/kubernetes/haproxy.cfg':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('protogalaxy/haproxy.cfg.erb'),
  }

  file { '/etc/kubernetes/manifests/haproxy.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('protogalaxy/haproxy.yaml.erb'),
    notify  => [Service['kubelet'],],
  }
}
