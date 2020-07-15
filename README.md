# protogalaxy

Puppet module governing the installation and bootstrapping of Kubernetes in Libretexts' second cluster, Galaxy.

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with protogalaxy](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with protogalaxy](#beginning-with-protogalaxy)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)

## Description

This module creates a High-Availability k8s cluster using kubeadm with stacked control plane nodes, keepalived/HAProxy in static pods as the k8s API server load balancer, Calico as the CNI, and metallb as the k8s load balancer.

## Setup

### Setup Requirements **OPTIONAL**

We're using this on nodes with Ubuntu 18.04 installed, so this module is untested on other setups. It theoretically works with Debian, but this is not verified. It doesn't work with other Linux distros that don't use apt.

### Beginning with protogalaxy

TODO

## Usage

TODO

## Reference

The reference should be available in [REFERENCE.md](REFERENCE.md).

## Limitations

This module is mainly intended to bootstrap LibreTexts' cluster specifically, and thus may not be suited for your needs. It also doesn't come with tasks to manage the k8s cluster after installation. If you want to use a better supported Kubernetes module, please use the [official](https://forge.puppet.com/puppetlabs/kubernetes) `puppetlabs-kubernetes` module.
