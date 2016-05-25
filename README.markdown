# ActiveMQ #

This module configures ActiveMQ.  It is primarily designed to work with
MCollective on Debian like systems. Ii is rework of https://github.com/puppetlabs/puppetlabs-activemq 
module.

 * [ActiveMQ](http://activemq.apache.org/)
 * [MCollective](http://www.puppetlabs.com/mcollective/introduction/)

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
node /eu-operation*./ inherits default
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

## Public Classes

#### Class: `activemq`
  
##### version
Version of activemq to install 

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

