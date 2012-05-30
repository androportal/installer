#!/bin/bash

#connect to device
adb connect $1

#pushing new default.prop for rooting purpose
adb push default.prop /
echo "STEP 1/7 : pushed default.prop to / for rooting purpose"

#pushing aakash.sh for chroot, mounting, and apache2
adb push aakash.sh /data/local/
echo "STEP 2/7 : pushed aakash.sh to /data/local/"
sleep 0.2

#hoping that device is rooted by default.prop, this modified init.rc has an
#entry to enable aakash.sh at boot time
adb push init.rc /
echo "STEP 3/7 : pushed init.rc for automatic affect of aakash.sh in future {Success}"
sleep 0.2

echo "pushing aakash.tar.gz to /data/local/. This might take more than 15 minutes,\
      keep your tablet alive and wifi active"
adb push aakash.tar.gz /data/local/
echo "STEP 4/7 : finally successfully pushed the giant, now even more painful step, untaring it..\
      keep your nerves down, this will again take more than 15 minutes"

adb push tar /data/local/
echo "STEP 5/7 : sent tar static binary"
adb shell chmod 777 /data/local/tar
echo "changed permissions of tar binary to execute"

echo "now untar the aakash.tar.gz to /data/local/linux, again this will take some time (15minutes)"
adb shell /data/local/tar -xvpzf /data/local/aakash.tar.gz /data/local/linux
echo "STEP 7/7 : all done "

sleep 1
echo "if you are here, that means everything went well."
echo "THE SYSTEM WILL REBOOT IN 5 SECONDS, HIT cntl+c to cancel"
sleep 5
adb reboot
echo "It will not reboot automatically, so turn it on NOW, YES NOW"

