# @summary Create keepalived static pod
#
# Create the keepalived static pod by placing its yaml in /etc/kubernetes/manifests
# and its relevant config file in /etc/kubernetes/keepalived.conf.
# This will make sure one and only one HAProxy will control the kubeapi IP address.
# This should be created on all control plane nodes.

# @example
#   include protogalaxy::loadbalancer_static_pods::keepalived
class protogalaxy::loadbalancer_static_pods::keepalived (
  String $vip = $protogalaxy::kubeapi_ip,
  Optional[String] $interface = $protogalaxy::network_interface,
  String $keepalived_image = $protogalaxy::keepalived_image
) {
  $interface = pick($interface, $facts['networking']['primary'])
  $is_primary = ($protogalaxy::role == 'initial_control')

  file { '/etc/kubernetes/check_haproxy.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('protogalaxy/check_haproxy.sh.erb'),
  }

  file { '/etc/kubernetes/keepalived.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('protogalaxy/keepalived.conf.erb'),
  }

  file { '/etc/kubernetes/manifests/keepalived.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('protogalaxy/keepalived.yaml.erb'),
    require => [Service['kubelet'],],
    notify  => [Service['kubelet'],],
  }
}
