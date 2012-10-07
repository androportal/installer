======
README
======

----------------------
What is this app for ?
----------------------

Aakash Programming Lab(APL) is a simplified learning tool for C, Cpp, Python and Scilab 
programming languages. It has a text editor to write code and terminal window to view output.
It has options to save code to sdcard or load existing code from sdcard. Scilab can handle plots too.
Each programming language has detailed inbuilt help(see our docs repository), starting from 
step by step instruction to use application and detailed programming language reference. You may want 
to download the ``docs`` repository to find more on developer manual.
A simple one page handout is `here <http://goo.gl/a6tRj>`_ .


-------------------------------------------
Installation of APL(Aakash Programming Lab)
-------------------------------------------

Please use ``alternate installation of APL`` for now.

Download the latest version of  `apl.tar.gz <https://docs.google.com/open?id=0B6KB6Sak5C4gLUxfaG5UOGlFT0E>`_
(190MB approx) and untar it into root of your internal or external sdcard.

The untar process will produce a file ``apl.img`` of around 700MB or less.

Remove the ``apl.tar.gz`` from your sdcard, if any. Do not remove ``apl.img``.

Then install ``APL.apk``, ``shutdown`` your device and ``start`` it again.

At this point, installation is over.

Now locate ``APL`` (green) icon in your android menu, select it to choose
your programming language preference. 

You can optionally check ``help`` inside option menu of each programming environment
for detailed user manual and language reference.


-----------------------------
Alternate Installation of APL
-----------------------------

Clone this repo or download the ``tar`` or ``zip``.

Download the latest version of `apl.tar.gz <https://docs.google.com/open?id=0B6KB6Sak5C4gLUxfaG5UOGlFT0E>`_ and keep it in the same ``installer`` directory. 

Now ``cd`` to installer directory and execute 

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
