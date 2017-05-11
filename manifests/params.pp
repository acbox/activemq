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
  $leveldb_datadir         = undef
  $leveldb_opts            = undef
  $log4j                   = true
  $persistent              = true
  $log4j_template          = "${module_name}/log4j.properties.erb"
  $log4j_stdout            = false
  $log4j_logdir            = '/var/log/activemq/'
  $owner                   = 'activemq'
  $group                   = 'activemq'
  $ssl                     = false
  $ssl_keystorepath        = undef
  $ssl_keystorepass        = 'puppet'
  $ssl_truststorepath      = undef
  $ssl_truststorepass      = 'puppet'
  $activemq_opts           = '-Dorg.apache.activemq.UseDedicatedTaskRunner=true'
  $java_xmx                = '512M'
  $java_xms                = '512M'
  $java_home               = '/usr/lib/jvm/default-java/'
  $memory_usage_limit      = $java_xmx
  $store_usage_limit       = '32M'
  $temp_usage_limit        = '32M'

  $mq_connectors           = undef
  $mq_connectors_ssl       = {
    'stomp+ssl' => {  uri => "stomp+ssl://0.0.0.0:61614?needClientAuth=true" }
  }
  $mq_connectors_default   = {
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
