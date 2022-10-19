# Hiera Demo

This repo demonstrates how hiera can be used to separate puppet code and data. It starts with a `dns` class that manages a dns nameservers in `/tmp/resolv.conf` and extracts the data steps so that the puppet code can be reused.

## Installation

On the puppetserver run:

```
rm -rf /etc/puppetlabs/code
git clone https://github.com/joshcooper/hiera_demo /etc/puppetlabs/code
chmod -R puppet:puppet /etc/puppetlabs/code
```

### Step 1

puppet defines a file resource whose content contains the dns nameserver.

```
content => "nameservers 10.240.1.10\n",
```

### Step 2

The data is extracted to common.yaml and an explicit call to the `lookup` function adds the data to the file resource.

```
content => lookup('dns::nameservers')
```

### Step 3

Since looking up class parameters is so common, puppet's automatic class parameter lookup will do that for you. The only requirement is that the class (`dns`) and class parameter name (`nameservers`) match the name of the key. Puppet will automatically inject the data into the catalog during compilation:

```
class dns(String $nameservers) {
  ...
}
```

### Step 4

Class parameters often need to be different operating systems, network domains or even individual nodes. Therefore we can define a hierarchy of data sources in our hiera config. The hierarchy is processed in order, following the "defaults with overrides" pattern:

```
  - name: "node-specific data"
    path: "sallow-bounce.delivery.puppetlabs.net.yaml"

  - name: "common data"
    path: "common.yaml"
```

But this doesn't really work as intended. What we really want is to lookup data based on the node whose catalog we're compiling.

### Step 5

A better option is to interpolate a path to our data source based on facts:

```
  - name: "domain data"
    path: "%{facts.networking.domain}.yaml"

  - name: "common data"
    path: "common.yaml"
```

Now we can create a data source for any domain whose data needs to be different than the default/common case. For example, in `data/delivery.puppetlabs.net.yaml`:

```
dns::nameservers: "nameservers 10.240.1.10\n"
```

