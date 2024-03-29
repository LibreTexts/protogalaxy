# @summary A short summary of the purpose of this class
#
# @param k8s_version
#   Version of the kubeadm, kubelet and kubectl packages to install.
#
# @param is_mgmt
#   Whether this node should only install packages relavent to kubernetes management.
#
# @param upgrading_cluster
#   If this boolean is true, do not enforce versions on kubelet.
#
# @example
#   include protogalaxy::packages {
#     k8s_version => '1.18.5',
#   }

class protogalaxy::packages (
  String $k8s_version = $protogalaxy::k8s_version,
  Boolean $is_mgmt = false,
  Boolean $upgrading_cluster = $protogalaxy::upgrading_cluster,
) inherits protogalaxy {

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
      'id'     => '7F92E05B31093BEF5A3C2D38FEEA9169307EA071',
      'source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
    }
  }

  if $is_mgmt {
    package { 'kubectl':
      ensure  => "${k8s_version}-00",
      mark    => hold,
      require => Class['Apt::Update'],
    }
    $latest_helm_version = @(EOF/L)
      $(curl -Ls https://github.com/helm/helm/releases | \
      grep 'href="/helm/helm/releases/tag/v3.[0-9]*.[0-9]*\"' | \
      grep -v no-underline | head -n 1 | cut -d '"' -f 6 | \
      awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}')
      | - EOF
    exec { "curl -sL https://get.helm.sh/helm-${latest_helm_version}-linux-amd64.tar.gz | tar zxO linux-amd64/helm > /usr/local/bin/helm":
      provider => shell,
      unless   => "test -e /usr/local/bin/helm -a $(helm version --template '{{.Version}}') = ${latest_helm_version}",
    }
  } else {
    package { 'containerd.io':
      ensure  => present,
      require => Class['Apt::Update'],
    }
    package { ['kubectl', 'kubeadm']:
      ensure  => "${k8s_version}-00",
      mark    => hold,
      require => Class['Apt::Update'],
    }
    unless $upgrading_cluster {
      package { 'kubelet':
        ensure  => "${k8s_version}-00",
        mark    => hold,
        require => Class['Apt::Update'],
      }
    }
  }
}
