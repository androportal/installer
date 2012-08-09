Warning
-------

This **branch** is not longer maintained and not recommended for daily
usage. The ``install.sh`` only works for older devices with Android
2.2. The installation is done through Wifi where both system and the
device should be in the same network. Read this document till the end
before you proceed for actual installation.


Prerequisite
------------

- Make sure your device is connected to wifi network.
- Note down the device's IP-address.
- The best case would be to give a static IP-address to the device.

Downloads
---------

Clone this branch by typing,

::

   git clone -b froyo-obsolete git@github.com:androportal/installer.git


and download ``linux.tar.gz`` form `here <http://tinyurl.com/8ddsjt3>`_

Installation
------------

Copy ``linux.tar.gz`` in ``installer`` directory. Make sure you have
at-least following file are in ``installer/``.

- install.sh
- default.prop
- aakash.sh
- init.rc
- linux.tar.gz
- tar
- MD5CHECK
- APL_v2.apk 


Open the terminal and change to the ``installer`` directory where all
the above files exist and type

::

   bash install.sh <IP-address-of-the-device>

for example

::

   bash install.sh 10.42.0.13

and follow the instructions which appears on the terminal.

Note 
-----

- Please make sure that you give the same IP-address at the second
  time you run ``install.sh``
- You need to ``turn ON`` the device manually.


