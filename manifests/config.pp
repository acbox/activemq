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
  $owner           = 'activemq',
  $group           = 'activemq',
  $java_home,
  $activemq_opts,
  $instance,
  $package,
  $mq_connectors,
  $cluster_nodes,
  $persistent,
  $server_config_show_diff = 'UNSET',
  $persistence_db_datadir,
  $persistence_db_opts,
  $persistence_db_type,
) {

  # Resource defaults
  File {
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    notify  => Service['activemq'],
    require => Package[$package],
  }

  if $persistence_db_datadir {
    file { $persistence_db_datadir:
      ensure => directory,
      before => File["${server_config_dir}/activemq.xml"],
    }
  }

  if $persistence_db_opts {
    validate_hash($persistence_db_opts)
  }

  if $server_config_show_diff != 'UNSET' {
    if versioncmp($settings::puppetversion, '3.2.0') >= 0 {
      File { show_diff => $server_config_show_diff }
    } else {
      warning('show_diff not supported in puppet prior to 3.2, ignoring')
    }
  }

  $server_config_real = $server_config

  file { [$server_config_dir,'/etc/activemq/instances-enabled']:
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
  
  file { "/usr/share/activemq/activemq-options":
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/activemq-options.erb"),
  }
}
