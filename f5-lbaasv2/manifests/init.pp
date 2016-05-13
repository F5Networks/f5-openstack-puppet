# == Class: lbaasv2
#
# Install the F5 Networks OpenStack Neutron LBaaSv2 Plugin and Agent on an
# OpenStack Neutron host to allow the configuration of LBaaSv2 objects
# on a F5 BIG-IP.
#
# === Parameters
#
#
# === Variables
#
#
# === Examples
#
#  class { lbaasv2: }
#
# === Authors
#
# F5 Networks openstackdev@f5.com
#
# === Copyright
#
# Copyright 2016 F5 Networks
#
# === License
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class lbaasv2 {
  
  $sitepackagedir = $osfamily ? {
    'RedHat'  =>  '/usr/lib/python2.7/site-packages/neutron_lbaas/drivers/',
    'Debian'  =>  '/usr/local/lib/python2.7/dist-packages/neutron_lbaas/drivers/',
  }

  package { 'f5-sdk':
    provider => 'pip',
    ensure => 'installed',
    before => Exec['get-server-provider-package']
  }

  exec { 'get-server-provider-package':
    cwd => '/tmp',
    command => '/usr/bin/curl -L -O https://github.com/F5Networks/neutron-lbaas/releases/download/v8.0.1/f5.tgz',
    before => Exec['install-server-provider-package']
  }

  #
  # Install in Site Package Dir 
  #
  exec { 'install-server-provider-package':
    cwd => $sitepackagedir,
    command => '/usr/bin/tar xvf /tmp/f5.tgz',
    before => Package['f5-os-agent']
  }

  package { 'f5-os-agent':
    name => 'git+https://github.com/F5Networks/f5-openstack-agent@v8.0.1',
    provider => 'pip',
    ensure => 'installed',
    before => Package['f5-os-lbaasv2-driver']
  }

  package { 'f5-os-lbaasv2-driver':
    name => 'git+https://github.com/F5Networks/f5-openstack-lbaasv2-driver@v8.0.1',
    provider => 'pip',
    ensure => 'installed',
    notify => Service['neutron-server']
  }

  service { 'neutron-server':
    ensure => 'running',
    enable => 'true',
    notify => Service['f5-openstack-agent']
  }

  service { 'f5-openstack-agent':
    ensure => 'running',
    enable => 'true',
    require => Service['neutron-server']
  }
}
