# ActiveMQ #

This module configures ActiveMQ.  It is primarily designed to work with
MCollective on Debian like systems. Ii is rework of https://github.com/puppetlabs/puppetlabs-activemq 
module.

 * [ActiveMQ](http://activemq.apache.org/)
 * [MCollective](http://www.puppetlabs.com/mcollective/introduction/)

## Parameters

##### version
version to install

##### package
package name to install

##### ensure 
one of latest|present(default)|absent

##### instance
instance name

##### kahadb_datadir
kahabd persistence directory 

##### kahadb_opts
special options for kahadb

##### persistent
if do you want to use persistent store true|false

##### webconsole
if do you want to install jetty webserver console true|false

##### mq_connectors
arrray of hashes with connectors list

##### ssl
enable ssl support true|false

##### ssl_keystorepath
java keystore path

##### ssl_keystorepass
java keystore password

##### ssl_truststorepath
java certificate truststore path

##### ssl_truststorepass
java certificate truststore password

##### activemq_opts
active mq process options

##### java_xmx
maximum memory for java process

##### java_xms
minimum allocated memory for java process

##### java_home
jdk home

##### memory_usage_limit
limit (in M|G|K) of memory to use

##### store_usage_limit
limit (in M|G|K) of persisent store

##### temp_usage_limit
limit (in M|G|K) of temporary storage

## Usage

### Default activemq instalation

The example in the tests directory provides a good example of how the ActiveMQ
module may be used.  In addition, the [MCollective
Module](http://forge.puppetlabs.com/puppetlabs/mcollective) provides a good
example of a service integrated with this ActiveMQ module.

    node default {
      class  { 'java':
        distribution => 'jdk',
        version      => 'latest',
      }
      ->
      class  { 'activemq': }
      ->
    }

### Activemq with ssl 
Example of instalation with ssl support for storm.
I used java_ks module for java certificate store creation from my X.509 keys/certs

```
node default
{
  $activemq_truststorepath='/etc/activemq/ca.jks'
  $activemq_truststorepass='puppet'

  $activemq_keystorepath='/etc/activemq/activemq.jks'
  $activemq_keystorepass='puppet'

  java_ks { 'puppetca:keystore':
    ensure          => latest,
    certificate     => '/var/lib/puppet/ssl/certs/ca.pem',
    target          => $activemq_truststorepath,
    password        => $activemq_truststorepass,
    trustcacerts    => true,
  }->
  java_ks { "${fqdn}:${activemq_keystorepath}":
    ensure         => latest,
    certificate    => '/var/lib/puppet/ssl/certs/mycert.pem',
    private_key    => '/var/lib/puppet/ssl/private_keys/mykey.pem',
    password       => $activemq_keystorepass,
  }->
  class {'activemq':
    kahadb_opts        => { journalMaxFileLength => "32mb" },
    ssl                => true,
    ssl_truststorepath => $activemq_truststorepath,
    ssl_truststorepass => $activemq_truststorepass,
    ssl_keystorepath   => $activemq_keystorepath,
    ssl_keystorepass   => $activemq_keystorepass,

  }

}
```

### Activemq without ssl but using hiera
Is possible to use this module with hiera as well

```
node default
{
  java::oracle { 'jdk8': }
  ->
  class  { 'activemq': }
}
```
And all vallues are in hiera file
```
activemq::memory_usage_limit: 512M
activemq::mq_connectors:
  stomp+nio:
    uri: stomp://0.0.0.0:61613
  openwire:
    uri: nio://0.0.0.0:61616
activemq::mq_cluster_brokers:
  int01:
    uri: static:(nio://int02:61616)
    duplex: false
  int02:
    uri: static:(nio://int01:61616)
    duplex: false
```

## Public Classes

#### Class: `activemq`
##### package
Package name= 'activemq'



# Contact Information #

 * Marian Schmotzer <smoco01@gmail.com>
 * [Module Source Code](https://github.com/puppetlabs/puppetlabs-activemq)

# Related Work #

The [puppetlabs-activemq](https://github.com/puppetlabs/puppetlabs-activemq) module
provided basics for this module.

# Web Console #

The module manages the web console by default.  The web console port is usually
located at port 8160:

 * [http://localhost:8160/admin](http://localhost:8160/admin)

To disable this behavior, pass in webconsole => false to the class.  e.g.

    node default {
      class { 'activemq':
        webconsole => false,
      }
    }

