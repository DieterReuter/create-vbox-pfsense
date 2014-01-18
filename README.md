create-vbox-pfsense
===================

Creates a complete VirtualBox machine for pfSense


# Prerequisites

Currently we only support `Mac OS X` (development and testing was done on Mac OS X Mavericks 10.9.1),
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


## First version is already working
This is the first running version of my script “make-pfsense-vbox.sh”. 
It will download the pfSense 2.1 ISO and creates a complete VM for use with VirtualBox.

There are some more useful script:

`vm-start.sh` - starts the VM from CLI

`vm-clean.sh` - stops/destroy the VM from CLI

`make-all.sh` - create a new VM (stops/destroy a running VM)


## ISO Overlays
You can now easily modify and overwrite every file within the original ISO image. 
Just make a copy of a specific file, put it in the `overlay-iso` folder, and change these files.

In the build process we'll mount and copy the original ISO imagei to a writable folder and merge it with the
`overlay-iso` folder.  All files from the overlay will be copied over the original ISO folder.  Now it's possible
to fully customize the content of the ISO.


# Licensing
Copyright (c) 2014 Dieter Reuter

MIT License, see LICENSE.txt for more details.
