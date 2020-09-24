# @summary A short summary of the purpose of this class
#
# @param k8s_version
#   Version of the kubeadm, kubelet and kubectl packages to install.
#
# @param docker_version
#   Version of docker-ce to install.
#
# @param role
#   Role of node given by site.pp
#
# @example
#   include protogalaxy::packages {
#     k8s_version => '1.18.5',
#     docker_version => '5:19.03.12~3-0~ubuntu-bionic',
#   }

class protogalaxy::packages (
  String $k8s_version = $protogalaxy::k8s_version,
  String $docker_version = $protogalaxy::docker_version,
  String $role = $protogalaxy::role,
){

  if $facts['os']['distro']['codename'] != 'bionic' {
    warning('Node is not using Ubuntu Bionic Beaver (18.04). This is untested.')
  }

  apt::source { 'docker':
    location => 'https://download.docker.com/linux/ubuntu',
    repos    => 'stable',
    release  => 'bionic',
    key      => {
      'id'     => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
      'source' => 'https://download.docker.com/linux/ubuntu/gpg',
    }
  }

  apt::source { 'kubernetes':
    location => 'https://apt.kubernetes.io/',
    repos    => 'main',
    release  => 'kubernetes-xenial',
    key      => {
      'id'     => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB',
      'source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
    }
  }

  case $role {
    'initial_control', 'control', 'worker': {
      package { 'docker-ce':
        ensure  => $docker_version,
        require => Class['Apt::Update'],
      }
      package { ['kubelet', 'kubectl', 'kubeadm']:
        ensure  => "${k8s_version}-00",
        mark    => hold,
        require => Class['Apt::Update'],
      }
    }
    'management': {
      package { 'kubectl':
        ensure  => "${k8s_version}-00",
        mark    => hold,
        require => Class['Apt::Update'],
      }
      $latest_helm_version = @(EOF/L)
        $(curl -Ls https://github.com/helm/helm/releases | \
        grep href="/helm/helm/releases/tag/v3.[0-9]*.[0-9]*\"' | \
        grep -v no-underline | head -n 1 | cut -d '"' -f 2 | \
        awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}')
        | - EOF
      exec { "curl -sL https://get.helm.sh/helm-${latest_helm_version}-linux-amd64.tar.gz | tar zxO linux-amd64/helm > /usr/local/bin/helm":
        provider => shell,
        unless   => "test -a /usr/local/bin/helm -a $(helm version --template '{{.Version}}') == ${latest_helm_version}",
      }
    }
    default: {}
  }
}
