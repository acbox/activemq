# Class: activemq::config
#
#   class description goes here.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class activemq::config (
  $server_config,
  $server_config_dir,
  $owner = 'activemq',
  $group = 'activemq',
  $kahadb_datadir,
  $kahadb_opts,
  $instance,
  $package,
  $mq_connectors,
  $server_config_show_diff = 'UNSET',
) {

  # Resource defaults
  File {
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    notify  => Service['activemq'],
    require => Package[$package],
  }

  if $kahadb_datadir {
    file { $kahadb_datadir:
      ensure => directory,
    }
  }

  if $kahadb_opts {
    validate_hash($kahadb_opts)
  }

  if $server_config_show_diff != 'UNSET' {
    if versioncmp($settings::puppetversion, '3.2.0') >= 0 {
      File { show_diff => $server_config_show_diff }
    } else {
      warning('show_diff not supported in puppet prior to 3.2, ignoring')
    }
  }

  $server_config_real = $server_config

  file { $server_config_dir:
    ensure => directory,
  }

  file { "/etc/activemq/instances-enabled/${instance}":
    ensure => link,
    target => $server_config_dir,
  }

  # The configuration file itself.
  file { "${server_config_dir}/activemq.xml":
    ensure  => file,
    mode    => '0600',
    content => $server_config_real,
  }

}
