
Please read this document till the end before to proceed for actual
installation


Prerequisite
------------
- Make sure your device is connected to wifi network.
- Note down the device's IP-address.
- The best case would be to give a static IP-address to the
  device.

Installation
------------

Make sure following file are in the same directory from where you run
``install.sh`` file

- install.sh
- default.prop
- aakash.sh
- init.rc
- linux.tar.gz
- tar
- MD5CHECK
- APL.apk 


Open the terminal and change to the directory where all the above
files exist and type::

   bash install.sh <IP-address>

for example::

   bash install.sh 10.42.0.13

and follow the instructions which appears on the terminal.

Note
----
- Please make sure that you give the same IP-address at the second
  time you run ``install.sh``
- You need to ``turn ON`` the device manually



What the script actually does?
------------------------------

*Less*

Aakash Programming Language, APL for short, is a web based front end
to four programming languages C, C++, Python and Scilab. In
the backend, we run a webserver in a ``chroot'd`` environment. The
``chroot`` environment is a custom made GNU/Linux distribution without any
'Xserver'. Instead of having a 'Xserver' which is high on both CPU and
memory, we use a X virtual framebuffer called ``Xvfb``. ``Xvfb`` is low on
both CPU and memory and requires no dedicated display hardware for
graphical display. All display of graphs in APL is done using ``Xvfb``.


*More*

The 'chroot' environment exist in the directory called ``linux`` which
is in the directory ``/data/local/`` of the device. The first step is
to make the path ``/data/local/`` writable, for this purpose the
script makes backup of file ``default.prop`` from the devices to the
working directory of host system and pushes a modified version of
``default.prop`` in ``/`` of the device. The device needs a reboot for
the changes to take effect.

The second step is to copy a tarball ``linux.tar.gz`` to the same
location ``/data/local/`` of the device and untar it. The script also
copies a binary `tar` file which does the work of extracting a
tarball. Once this is done, we have an ``chroot`` environment
ready. The hierarchy of ``/data/local/linux/`` is same as any other
GNU/Linux distribution, but completely inactive with 'no' web-server and
graphical support.

The mounting of file-systems such as ``/proc``, ``/sys`` and
``/dev/pts/`` is done by another bash script ``aakash.sh`` which also
takes care of initiating a webserver every time the device is turned
ON. ``aakash.sh`` also sets an display environment by initiating an
virtual framebuffer environment using ``Xvfb``. ``aakash.sh`` script
is called by Android's ``init.rc`` file at boot time.

- below lines in ``init.rc`` calls ``aakash.sh``::

           service myscript /data/local/aakash.sh
	       oneshot


Once all the files and directories are in place, ``install.sh`` script
does the work of cleanup. This will remove all temporary file created
at the time of installation and lock the device back by updating the 
original ``default.prop``.
For more details, please refer respective bash scripts.

Please mail us for any further query:

srikant@fossee.in

isachin@iitb.ac.in
