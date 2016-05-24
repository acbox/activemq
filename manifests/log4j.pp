# Class: activemq::log4j
#
# This submodule manages log4j setting for ActiveMQ
#
class activemq::log4j(
  $log4j_template,
  $log4j_stdout,
  $log4j_logdir,
  $server_config_dir,
  $owner,
  $group,
  $log4j,
) {
  File {
    owner   => $owner,
    group   => $group,
  }
  if $log4j_logdir =~ /^\/var\/log[\/]*$/ {
    err("Parameter log4j_logdir cannot be $log4j_logdir - can break other puppet modules")
  }
  if $log4j {
    file {$log4j_logdir:
      ensure  => directory,
    }

    file {"${server_config_dir}/log4j.properties":
      content => template($log4j_template),
      ensure  => file,
    }
  }else{
    file {$log4j_logdir:
      ensure  => absent,
    }
    file {"${server_config_dir}/log4j.properties":
      ensure  => absent,
    }
  }


}

