#!/bin/bash

chmod 777 adb

echo "Sending aakash.sh..."
./adb push aakash.sh /data/local/

echo "Sending preinstall.sh..."
./adb push preinstall.sh /system/bin/

echo "Sending debug.sh...."
./adb push debug.sh  /data/local/

echo "Sending apl.img, this will take around 10 minutes "
./adb push apl.img /mnt/sdcard/

./adb shell sync

echo "Installing APL.apk... "
./adb install APL.apk

echo "Device will reboot in 5 seconds..press cntrl + c  to abort auto rebooot.."
sleep 5
./adb reboot
