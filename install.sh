#!/bin/bash 

# CAUTION: Don't edit this file unless you are very sure.

declare FILE_PATH="/data/local/" 
declare TAR_FILE="linux.tar.gz"
declare TAR_FILE_PATH="/mnt/sdcard/"
declare APK="APL.apk"

killall adb
adb kill-server

adb push preinstall.sh /system/bin/preinstall.sh
adb push tar $FILE_PATH
adb push aakash.sh $FILE_PATH
adb push bind.sh $FILE_PATH
adb push debug.sh $FILE_PATH

echo "Copying linux.tar.gz...will take aprroximately a minute..."
adb push $TAR_FILE $TAR_FILE_PATH

echo "uncompressing linux.tar.gz..will take a while..seriously...approximately 10 to 15 minutes.."
echo "Uncompressing linux.tar.gz to /data/local/linux...."
adb shell ${FILE_PATH}tar -xvpzf ${TAR_FILE_PATH}${TAR_FILE} -C ${FILE_PATH}

echo "installing apk file..."
adb install $APK

echo "removing linux.tar.gz file from /sdcard"
adb shell rm ${TAR_FILE_PATH}${TAR_FILE}

echo "will reboot Aakash in 5 seconds....press control+c to abort auto reboot"
sleep 5
adb reboot
