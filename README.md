create-vbox-pfsense
===================

Creates a complete VirtualBox machine for pfSense


# Prerequisites

Currently we only support `Mac OS X` (development and testing was on Mac OS X Mavericks 10.9.1),
Linux support later (on request).

In order to build an run the VirtualBox machine, we need some other tools on our dev box.

[VirtualBox](http://virtualbox.org) to create and run the pfSense Box. 

[MacPorts](http://www.macports.org/install.php) to install `cdrtools` and `mkisofs` tools .

   `port install cdrtools` - we need `mkisofs` to manipulate the original ISO image


## Getting started
Just clone this repo and build/start your pfSense VBox with the following commands:

    git clone https://github.com/DieterReuter/create-vbox-pfsense.git
    cd create-vbox-pfsense
    ./make-pfsense-vbox.sh

# Licensing
Copyright (c) 2014 Dieter Reuter

MIT License, see LICENSE.txt for more details.
