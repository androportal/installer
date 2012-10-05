README
======

What is this app for ?
----------------------

* Will detect the device and show its MAC address for easy documentation

* Will auto sync with the ftp server for latest updated applications

* Install all apps and data files to respective directories


Requires
--------

* curlftpfs

* rsync

* adb

* If you are on 64 bit machine then install ia-32 libs, as ``adb`` only comes
  for x86 machines

* Also requires internal LAN connection to ftp server


How to install ?
----------------

The alien way::

       sudo apt-get install curlftpfs rsync
       mv aakash-installer.py aakash
       chmod a+x aakash adb
       sudo cp aakash /bin
       sudo cp adb /bin

A easier way would be using ``deb`` package, which contains all the dependencies
``(curlftpfs, rsync, adb)`` except ia-32 libs

The link of ``deb`` file will be uploaded soon


How to use this ?
-----------------

Open terminal and type ``aakash`` on the prompt. Connect the aakash with USB cable
to your Linux machine. That's all, observe the installation messages on the screen. 
There will be a directory name ``aakash`` will be created on the Desktop which 
contain all synced data and apks from ftp server. If you try to change in ``~/Desktop/aakash``
directory it won't work out because when you run the installer it will remove any local 
modifications and sync with the ftp server again.

Optionally you can turn ``ON`` your aakash's WiFi to view its MAC address. No wireless
connection is required, turning ``ON`` the WiFi is sufficient. 


Application flags:
------------------

1. This will start the application, and will ask for your sudo password ::

        $ aakash     
       
#. Same as above but without ftp sever check, force install(-f) ::

        $ aakash -f
              
#. Only get the MAC address(-m) ::

        $ aakash -m
                     
#. Only push apk's, skip the data(-a) ::

        $ aakash -a
                            
#. Show this help(-h) ::

        $ aakash -h  

#. Show full offline help in web browser(-hb) with your choice of browser ::

        $ aakash -hb firefox


How to upload my apps on the ftp server(for aakash developers only) ?
---------------------------------------------------------------------

1. Let us assume we have a ftp URL as : ``ftp://127.0.0.1/aakash`` on web browser

#. Inside our Linux ftp server the ``aakash`` directory is located at ``/srv/ftp/aakash``

#. Please create a directory of your application name inside ``/srv/ftp/aakash``

#. Let us take an example for ``clicker`` application ::

         mkdir -p /srv/ftp/aakash/clicker

#. Now create two optional subdirectories inside ``/srv/ftp/aakash/clicker`` which will 
   hold the ``apk`` and ``data`` (if any)::

        mkdir -p /srv/ftp/aakash/clicker/apk
        mkdir -p /srv/ftp/aakash/clicker/data

#. If your application doesn't require any ``data`` then you may not create the ``data``
   directory.

#. Now copy your ``apk(s)`` to ``/srv/ftp/aakash/clicker/apk`` and make sure you name them
   according to some version(not necessary but recommended) ::

        cp Clicker.apk /srv/ftp/aakash/clicker/apk

   Now if your application doens't need any data files then you can stop here. You have 
   successfully uploaded your ``apk`` on to ftp server.


#. Now with ``data``. To put your data files(xml, videos, scripts etc) in 
   ``/srv/ftp/aakash/clicker/data`` follow the previous approach, i.e copy them to 
   data directory first. Please remember ``data`` can be a file or a directory, the procedure
   will be same for both ::

        cp -r data-directory/ /srv/ftp/aakash/clicker/data/
        cp  myfile /srv/ftp/aakash/clicker/data/


#. Now as your data files/directories are copied inside the data directory,
   the next step would be to tell the installer application that where you want to 
   push them in ``aakash tablet(for eg: /mnt/sdcard/clicker)``.
   
#. To do so, create a plain text file and name it as ``path``. Open this file in your favorite 
   editor and add your source file/directory name and destination path(aakash's path).

   Sample content of ``path`` file as per our previous example ::

        data-directory,/mnt/sdcard/
        myfile,/data/local/

    
   That's it, save this file and copy it to ``/srv/ftp/aakash/clicker/data/`` ::

        cp path /srv/ftp/aakash/clicker/data/

    At this point your ``/srv/ftp/aakash/clicker/data/`` directory contains 2 files
    (myfile, path) and one directory (data-directory/).

#. Everytime you change your data file or directory you should also reflect it 
    in ``path`` file.


As ``path`` file is a ``csv`` file (comma separated file), so please do not add any 
additional characters in this file. Start from the first line first character.


For any query contact developer through github or email.

