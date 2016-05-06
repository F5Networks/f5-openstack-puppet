# == Class: lbaasv2
#
# Full description of class lbaasv2 here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { lbaasv2:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
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
