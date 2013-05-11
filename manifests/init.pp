# Class: datadog
#
# This class contains the agent installation mechanism for the Datadog module
#
# Parameters:
#   $api_key:
#       Your DataDog API Key. Please replace with your key value
#   $puppet_run_reports
#       Will send results from your puppet agent runs back to the datadog service
#   $puppetmaster_user
#       Will chown the api key used by the report processor to this user.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# include datadog
#
# or
#
# class{'datadog': api_key => 'your key'}
#
#
class datadog (
  $api_key            = $datadog::params::api_key,
  $puppet_run_reports = $datadog::params::puppet_run_reports,
  $puppetmaster_user  = $datadog::params::puppetmaster_user,
  $dd_url             = $datadog::params::dd_url,
  $dd_hostname        = $datadog::params::dd_hostname,
  $dd_debug_mode      = $datadog::params::dd_debug_mode
) inherits datadog::params {

  case $::operatingsystem {
    'Ubuntu','Debian': { include datadog::debian }
    'RedHat','CentOS','Fedora','Amazon': { include datadog::redhat }
    default: { notify{ 'Unsupported platform': } }
  }

  file { '/etc/dd-agent':
    ensure   => 'directory',
    owner    => 'root',
    group    => 'root',
    mode     => '0755',
    require  => Package['datadog-agent'],
  } -> file { '/etc/dd-agent/datadog.conf':
    content  => template('datadog/datadog.conf.erb'),
    owner    => 'dd-agent',
    group    => 'root',
    mode     => '0640',
    notify   => Service['datadog-agent']
  }

  if $puppet_run_reports {
    class { 'datadog::reports':
      api_key           => $api_key,
      puppetmaster_user => $puppetmaster_user,
    }
  }
}
