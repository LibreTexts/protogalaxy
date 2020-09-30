# @summary A short summary of the purpose of this class
#
# @param role
#   Role of node given by site.pp 
#
# @example
#   include protogalaxy::cluster_reset

class protogalaxy::cluster_reset (
  String $role = $protogalaxy::role,
){
  unless $role == 'management' {
    exec { 'kubeadm reset':
      command => 'usr/bin/kubeadm reset',
    }
  }
}
