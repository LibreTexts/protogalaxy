# protogalaxy

This is a Puppet module governing the installation and bootstrapping of Kubernetes in LibreTexts' second cluster, Galaxy.

#### Table of Contents

1. [Description](#description)
2. [Architecture](#architecture)
    * [Network Architecture](#network-architecture)
    * [Node Types](#node-types)
    * [Load balancing the k8s API server](#load-balancing-the-k8s-api-server)
3. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Setting up the Hiera values](#setting-up-the-hiera-values)
    * [Writing node definitions](#writing-node-definitions)
    * [Things to do after protogalaxy](#things-to-do-after-protogalaxy)
4. [Limitations](#limitations)

## Description

This module creates a highly available kubernetes cluster using kubeadm with stacked control plane nodes (etcd running as static pods), along with keepalived/HAProxy in static pods as the k8s API server load balancer. In the case that one control plane node goes down, the others can still keep the cluster running as long as there is a majority.

This module differs from the official puppetlabs-kubernetes module in two major ways:
1. The official module requires pre-generating the entire PKI to bootstrap the cluster with (and specifying them in Hiera values). Our module tries to leave as many things to kubeadm by default.
2. The official module doesn't have a load balancer that ensures a highly available setup (you can either have one control plane node, or bring your own load balancer). Our module uses a keepalived+HAProxy setup on every control plane node to ensure high availability.

This, along with some other factors (such as the official module using an external etcd cluster, and being out-of-date), caused us to write this module instead.

## Architecture

### Network Architecture

We're assuming all nodes are under the same CIDR, and can talk to each other freely. We also assume each node has a fixed IP address (either throug having static IPs on the interface, or through having a DHCP server that hands out fixed IP addresses). You should know the IP addresses beforehand.

### Node Types

We have 4 types of nodes:

1. Initial control plane node. This node will be running `kubeadm init` and creating the cluster. After the cluster is operational, this should behave similarly to other control plane nodes, although this one should have priority in terms of keepalived. There should only be one initial control plane node.
2. Additional control plane nodes. These will also be running the kubernetes API server and other related services. Note that when choosing the total number of control plane nodes to have, you should always have an odd number of control plane nodes when possible (see the [etcd FAQ](https://etcd.io/docs/v3.4.0/faq/) for why this is).
3. Worker nodes. These are just regular Kubernetes worker nodes.
4. Management nodes. These nodes won't have any kubeadm commands run on it, but protogalaxy will automatically install kubectl and helm on it, and ensure helm is always at the latest version. You can copy `/etc/kubernetes/admin.conf` from the initial control plane node to `~/.kube/config` on the management node, and that allows you to use kubectl to control the cluster.

### Load balancing the k8s API server

The main point of this design is to make sure no matter which node goes down, the cluster can continue running. This means we can't just specify one control plane node as the k8s API endpoint, because when that node goes down, even if the control plane is still functional, all workers cannot communicate with the control plane. Therefore, we're using a keepalived + HAProxy setup as a load balancer.

We reserve a "virtual IP" that is controlled by the load balancer. You should make sure this IP is in the CIDR of nodes, but not conflict with any node IP. As an example, our cluster uses 10.0.0.1/24 for nodes, and all machines use something between 10.0.0.100~10.0.0.120. We chose 10.0.0.150 as the virtual IP. This IP is where the kubernetes API server will be accessible at.

#### keepalived


#### HAProxy


## Setup

### Setup requirements

We're making some assumptions in this module, most notably that you're using Ubuntu 20.04 on all nodes. Older versions of Ubuntu may work, but is not tested. Other debian based distributions might work, but we're using Ubuntu-specific apt repos, so be very careful. Non Debian based machines will not work since we use apt.

### Setting up the Hiera values

All of this module's parameters are configured through Hiera values. To use this, please specify the following values for all nodes:

- `protogalaxy::kubeapi_ip`: The virtual IP where the Kubernetes API server will reside. See our [architecture](#architecture) to understand what this means.
- `protogalaxy::discovery_token`: A hardcoded discovery token used for the bootstrap process, formatted [according to the Kubernetes documentation](https://v1-16.docs.kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/#token-format).
- `protogalaxy::certkey`: A hardcoded 32-byte certificate key used to bootstrap control plane nodes. This can be randomly generated using `openssl rand -hex 32`.
- `protogalaxy::control_plane_nodes`: A list of control plane nodes, so HAProxy knows where to proxy the requests to. This should be specified as an array of strings like "hostname:ip".
- `protogalaxy::pod_cidr`: The CIDR used by your network plugin of choice.

You can also specify the following optional values. If you don't, some defaults are used:

- `protogalaxy::service_cidr`: The CIDR used by Kubernetes services internally. Defaults to `10.96.0.0/12`.
- `protogalaxy::k8s_version`: The version of Kubernetes to install. Defaults to `1.19.2`.
- `protogalaxy::docker_version`: The version of Docker to install. Defaults to `5:19.03.13~3-0~ubuntu-bionic`.
- `protogalaxy::network_interface`: Specify a network interface for the Kubernetes control plane to bind to. Defaults to empty, which lets kubeadm decide by itself. This is useful when you have multiple network interfaces and kubeadm doesn't detect the right one correctly.
- `protogalaxy::keepalived_image`: The image to use for the keepalived service. Defaults to `rkevin/keepalived:2.0.20` (Dockerfile available [here](https://hub.docker.com/r/rkevin/keepalived)).
- `protogalaxy::haproxy_image`: The image to use for HAProxy. Defaults to `haproxy:2.2-alpine`.
- `protogalaxy::upgrading_cluster`: Boolean to indicate you are upgrading the cluster. For more details on how to use it, refer to our [upgrading documentation](https://github.com/LibreTexts/metalc/blob/master/docs/Galaxy-Control-Repo.md#upgrading-the-kubernetes-cluster). Defaults to false.
- `protogalaxy::reset_cluster`: Boolean to indicate you want to reset the cluster. This rips out the cluster so you can start with a fresh k8s install. Defaults to false.

### Writing node definitions

Once the Hiera values are there, you can include the relevant classes in the node definitions. Here's an example taken from our control repo, where `nebula1` is the first control plane node, `nebula*` are additional control plane nodes, `star*` are worker nodes and `gravity` is the management node:

```puppet
node nebula1 {
  require protogalaxy::role::initial_control
}

node /^nebula\d+$/ {
  require protogalaxy::role::control
}

node /star\d+$/ {
  require protogalaxy::role::worker
}

node gravity {
  require protogalaxy::role::management
}
```

This should go in your `site.pp` (or whatever you call your main manifest file) in your control repo.

If you're using r10k, remember to add this module to your `Puppetfile` like this:

```
mod 'puppetlabs/stdlib'
mod 'puppetlabs/apt'
mod 'protogalaxy',
  git: 'https://github.com/LibreTexts/protogalaxy',
  branch: 'master'
```

We're just using the master branch because this module is currently only used internally. If you'd like to use our module, please let us know and we can maybe tag a stable branch.

After you set everything up, you may do a puppet run on all nodes. Please do so within a couple hours of each other, as the kubeadm tokens will expire after 24 hours.

### Things to do after protogalaxy

You need to copy the `/etc/kubernetes/admin.conf` file from the initial control plane node to `~/.kube/config` on the management node in order for the management node to use `kubectl` commands. This step is manual because it's hard for different nodes to share data between them using puppet.

This module doesn't add anything else to the k8s cluster once it's running. To have a functional cluster, you'll need a [CNI plugin](https://kubernetes.io/docs/concepts/cluster-administration/networking/) installed (we're using Multus+Calico, but you can use whatever) before pods can talk to one another.

We also recommend installing stuff like [MetalLB](https://metallb.universe.tf/) to expose services of type LoadBalancer to the outside world, but it's not required.

## Limitations

This module is mainly intended to bootstrap LibreTexts' cluster specifically, and thus may not be suited for your needs. We have a very particular architecture in mind (as mentioned [earlier](#architecture)), and your network may differ drastically. We hope this module might provide some inspiration, though!

This module also doesn't come with puppet tasks to manage the k8s cluster after installation. We made the decision to only use kubectl / helm to manage our Kubernetes resources, and store our k8s objects in a configuration repo. If you need to use Puppet to manage k8s resources, or want to use a better supported Kubernetes module, please use the [official](https://forge.puppet.com/puppetlabs/kubernetes) `puppetlabs-kubernetes` module.
