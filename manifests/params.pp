# Private
class activemq::params {
  $version                 = 'present'
  $package                 = 'activemq'
  $ensure                  = 'running'
  $instance                = 'activemq'
  $server_config           = 'UNSET'
  $server_config_show_diff = 'UNSET'
  $service_enable          = true
  $mq_broker_name          = $::fqdn
  $mq_admin_username       = 'admin'
  $mq_admin_password       = 'admin'
  $mq_cluster_username     = 'amq'
  $mq_cluster_password     = 'secret'
  $mq_cluster_brokers      = []
  $kahadb_datadir          = '/var/lib/activemq/data/'
  $kahadb_opts             = undef
  $log4j                   = true
  $log4j_template          = "${module_name}/log4j.properties.erb"
  $log4j_stdout            = false
  $log4j_logdir            = '/var/log/activemq/'
  $owner                   = 'activemq'
  $group                   = 'activemq'
  $ssl                     = false
  $mq_connectors           = { 
        'stomp+nio' => {  uri => "stomp://0.0.0.0:61613" } 
  }
  # Debian does not include the webconsole
  case $::osfamily {
    'Debian': {
      $webconsole = false
      $server_config_dir = "/etc/activemq/instances-available/${instance}"
    }
    default: {
      $webconsole = true
      $server_config_dir = "/etc/activemq/"
    }
  }
}
