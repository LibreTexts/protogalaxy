class protogalaxy::roles {
  if $controller or $worker {
    install_docker
    install_kube_packages
  }
  if $controller {
    create_keepalived_static_pod 
