# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include protogalaxy::packages
class protogalaxy::packages (
  String $k8s_version = $protogalaxy::k8s_version,
  String $docker_version = $protogalaxy::docker_version,
){

  if $facts['os']['distro']['codename'] != 'bionic' {
    warning('Node is not using Ubuntu Bionic Beaver (18.04). This is untested.')
  }

  apt::source { 'docker':
    location => 'https://download.docker.com/linux/ubuntu',
    repos    => 'bionic',
    key      => {
      'id'     => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
      'source' => 'https://download.docker.com/linux/ubuntu/gpg',
    }
  }

  apt::source { 'kubernetes':
    location => 'https://apt.kubernetes.io/',
    repos    => 'kubernetes-xenial',
    key      => {
      'id'     => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB',
      'source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
    }
  }

  package { 'docker-ce':
    ensure  => $docker_version,
    require => Class['Apt::Update'],
  }

  package { ['kubelet', 'kubectl', 'kubeadm']:
    ensure  => $k8s_version + '-00',
    mark    => hold,
    require => Class['Apt::Update'],
  }
}
