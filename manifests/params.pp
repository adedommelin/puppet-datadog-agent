# Class: datadog::params
#
# This class contains the parameters for the Datadog module
#
# Parameters:
#   $api_key:
#       Your DataDog API Key. Please replace with your key value
#   $dd_url
#       The URL to the DataDog application.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class datadog::params {
  $api_key            = hiera('datadog_api_key', $::datadog_api_key)
  $dd_hostname        = hiera('datadog_hostname', $::fqdn)
  $dd_url             = hiera('datadog_url','https://app.datadoghq.com')
  $dd_debug_mode      = hiera('datadog_debug_mode', false)
  $puppet_run_reports = hiera('datadog_run_reports',false)
  $puppetmaster_user  = hiera('puppetmaster_user', 'puppet')


  if ! $::puppetversion =~ /(i?)enterprise/ {
    case $::operatingsystem {
      'Ubuntu','Debian': {
        $rubygems_package = 'rubygems'
        $rubydev_package  = 'ruby-dev'
      }
      'RedHat','CentOS','Fedora','Amazon': {
        $rubygems_package = 'rubygems'
        $rubydev_package  = 'ruby-devel'
      }
      default: { notify{ 'Unsupported platform': } }
    }
  }
}
