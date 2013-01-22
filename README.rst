======
README
======

----------------------
What is this app for ?
----------------------

`Aakash <http://www.iitb.ac.in/AK/Aakash.htm>`_ Programming Lab(APL) is a simplified learning tool for C, Cpp, Python and Scilab 
programming languages. It has a text editor to write code and terminal window to view output.
It has options to save code to sdcard or load existing code from sdcard. Scilab can handle plots too.
Each programming language has detailed inbuilt help(see our docs repository), starting from 
step by step instruction to use application and detailed programming language reference. You may want 
to download the ``docs`` repository to find more on developer manual.
A simple one page handout is `here <http://goo.gl/a6tRj>`_ .

NB: This application is tested only on Aakash tablets, Others may use it at their own risk after suitable changes. 

===========================================
Installation of APL(Aakash Programming Lab)
===========================================

Simple and recommended installation procedure
---------------------------------------------

#. This process requires a working internet connection. If you're behind proxy, then set ``no proxy`` for 127.0.0.1 in your WiFi proxy settings.
   This is not required for normal direct internet connections

#. Download the latest APL.apk from `here<https://raw.github.com/androportal/installer/ics/APL.apk>`_ and install it on your Aakash

#. Click on green color icon(labeled APL) in android menu and allow it to download the ``~180MB`` image file

#. The download and uncompress process will take some while, you need to reboot the device to complete installation


Alternate way of installation
-----------------------------

Download the latest version of apl image in ``tar`` or ``zip`` format. 
`apl.tar.gz <https://github.com/downloads/androportal/installer/apl.tar.gz>`_ or `apl.img.zip <https://github.com/downloads/androportal/installer/apl.img.zip>`_
The untar or unzip process of above file will produce ``apl.img`` of around 700MB or less on your computer. Copy
``apl.img`` to sdcard(internal or external) of your Aakash tablet.

Then install `APLv1.0.apk <https://github.com/downloads/androportal/APL-apk/APL-v1.0.apk>`_ in your Aakash, ``shutdown``
and ``start`` your Aakash to finish installation. 

Now locate ``APL`` (green) icon in your android menu, select it to choose
your programming language preference. 

You can optionally check ``help`` inside option menu of each programming environment
for detailed user manual and language reference.


-------------------------------------------------
Yet another alternate Installation process of APL
-------------------------------------------------

Download the ``tar`` or ``zip`` of this repository.

.. Download the latest version of `apl.tar.gz <https://docs.google.com/open?id=0B6KB6Sak5C4gLUxfaG5UOGlFT0E>`_ or 
.. `apl.img.zip <https://docs.google.com/file/d/0B6KB6Sak5C4gbTRiLXlJdDJ0TDQ/edit>`_ 

Download the latest version of `apl.tar.gz <https://github.com/downloads/androportal/installer/apl.tar.gz>`_ or
`apl.img.zip <https://github.com/downloads/androportal/installer/apl.img.zip>`_ and keep it in the same ``installer-ics`` directory in your Linux machine. 

Now ``cd`` to ``installer-ics`` directory and execute 

::

    sudo bash install.sh

The device will reboot on success. That's all, don't repeat any step from previous method.


--------------------------------------------
Uninstallation of APL for both above methods
--------------------------------------------

Locate ``Aakash Programming Lab(APL)`` in `settings -> Apps` and uninstall.

Restart the device and then remove the ``apl.img`` from your sdcard.


-------
Caution
-------

Ensure around 700MB space in your sdcard for proper installation. 

Do not remove ``apl.img`` while app is in use.

Follow the ``uninstall`` procedure strictly. 

Please note that, this app is tested only on Aakash tablet, you may download it and 
use it for any other device, if it run successfully on your platform please let us
know. There is a branch for froyo too.

-------
LICENSE
-------
GNU GPLv3
