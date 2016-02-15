# pci_devices_fact

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with pci_devices_fact](#setup)
    * [What pci_devices_fact affects](#what-pci_devices_fact-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pci_devices_fact](#beginning-with-pci_devices_fact)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module provides the `pci_devices`-fact, which contains an array of PCI IDs for the node.

The `pci_devices` fact can then be used to check available hardware on the node from within Puppet manifests.

## Setup

### Setup Requirements

This module requires pushing a new fact to the node, and therefore requires Plugincync to be enabled.
The fact is returned as an array, so if you are running Puppet 3.8 or older, you need to verify that the [`stringify_facts`](https://docs.puppetlabs.com/puppet/3.8/reference/configuration.html#stringifyfacts) option is set to `false`.

### Beginning with pci_devices_fact

Once the module is installed, you can access the `pci_devices` fact from manifests:

```
notice($::pci_devices)
```

## Usage

The `pci_devices` fact can be used to test for specific hardware in Puppet manifests.
The simplest way is to use the [`in`-operator](https://docs.puppetlabs.com/puppet/latest/reference/lang_expressions.html#in) to check for the precence of one element in the array.

For example, to install the Realtek firmware in the precense of one of their WiFi adapters:

```
if '10ec:8176' in $::pci_devices {
  ensure_packages('firmware-realtek')
}
```

## Reference

This module provides a single fact:

### `pci_devices`

An array of PCI device identifiers for devices in the node.
For example:

```
pci_devices => [
  '10ec:8168',
  '10ec:8176',
  '1b21:1142',
  '8086:0154',
  '8086:0156',
  '8086:1e03',
  '8086:1e10',
  '8086:1e12',
  '8086:1e14',
  '8086:1e16',
  '8086:1e20',
  '8086:1e22',
  '8086:1e26',
  '8086:1e2d',
  '8086:1e3a',
  '8086:1e5f',
]
```

## Limitations

This module retrieves the device list by enumerating the PCI devices found in sysfs on Linux.
As such, only Linux is supported, and sysfs musb be available to the Puppet agent.

## Development

This module is hosted in a [Git repository at GitHub](https://github.com/olavmrk/puppet-pci_devices_fact).
