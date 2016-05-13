# lbaasv2

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with lbaasv2](#setup)
    * [What lbaasv2 affects](#what-lbaasv2-affects)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Install the F5 Networks OpenStack Neutron LBaaSv2 Plugin and Agent on an
OpenStack Neutron host to allow the configuration of LBaaSv2 objects
on a F5 BIG-IP.

## Module Description

This module enables the use of the F5 Networks BIG-IP product in
OpenStack environments for use with the Neutron advanced service, Load
Balancing as a Service. The use of this module will result in the
installation of the required components to enable F5's LBaaSv2 plugin,
driver and agent.

This module does not add configuration, the adminstrator will need to
update the following configurations after installation and restart
the neutron service.

* /etc/neutron/neutron.conf
* /etc/neutron/neutron_lbaas.conf
* /etc/neutron/services/f5/f5-openstack-agent.ini

More information can be found in the [F5 Networks OpenStack LBaaSv2
documentation](http://f5-openstack-lbaasv2.readthedocs.io/en/latest/index.html).

## Setup

### What lbaasv2 affects
This module installs the following:

* [F5 LBaaSv2 Service Provider Package](https://github.com/F5Networks/neutron-lbaas/releases)
* [F5 OpenStack LBaaSv2 Driver](https://github.com/F5Networks/f5-openstack-lbaasv2-driver)
* [F5 OpenStack Agent](https://github.com/F5Networks/f5-openstack-agent)

## Limitations

* Supports OpenStack Liberty release only

## Development

See our [contributing guide on GitHub](https://github.com/F5Networks/f5-openstack-puppet).
