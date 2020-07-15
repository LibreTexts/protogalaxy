define protogalaxy::keepalived_static_pod (
  String $vip = $protogalaxy::kubeapi_ip,
  Boolean $is_primary = false,
  Optional[String] $interface,
  String $keepalived_image = $protogalaxy::keepalived_image
) {
  $interface = pick($interface, $facts.networking.primary)

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
    require => [
      services['kubelet'],
      # TODO config from nebula0
    ],
  }
}

define protogalaxy::haproxy_static_pod (
  String $vip = $protogalaxy::kubeapi_ip,
  Optional[String] $interface,
  String $haproxy_image = $protogalaxy::haproxy_image
) {
  $interface = pick($interface, $facts.networking.primary)
  $nodes = [] # todo
  file { '/etc/kubernetes/haproxy.cfg':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('protogalaxy/haproxy.cfg.erb'),
  }

  file { '/etc/kubernetes/manifests/keepalived.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('protogalaxy/keepalived.yaml.erb'),
    require => [
      services['kubelet'],
      # TODO config from nebula0
    ],
  }
}
