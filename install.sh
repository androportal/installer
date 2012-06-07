#!/bin/bash

# ---- global variable ----
declare ARG_COUNT=$#
declare IP=$1

declare TAR_FILE="linux.tar.gz"
declare UNINSTALL_APK="com.example.option"
declare APK="*.apk"
declare AAKASH="aakash.sh"

declare DEV_PATH="/data/local/"

declare MD5GEN=$(md5sum $TAR_FILE | cut -d " " -f 1 -)
declare MD5FILE=$(cat MD5CHECK | cut -d " " -f 1 -)
# -------------------------

function sanity_check()
{
    echo "checking whether all files are in place..."
    
    if [ ! -f $AAKASH ];
    then
	echo "$AAKASH: not found"
	exit 0
    elif [ ! -f $TAR_FILE ];
    then
	echo "$TAR_FILE: not found"
	exit 0
    elif [ ! -f default.prop ];
    then
	echo "default.prop: not found"
	exit 0
    elif [ ! -f init.rc ];
    then
	echo "init.rc: not found"
	exit 0
    elif [ ! -f tar ];
    then
	echo "binary 'tar': not found"
	exit 0
    elif [ "$MD5GEN" != "$MD5FILE" ];
    then
	echo "ERROR: MD5 checksum FAILED!, may be you are using a wrong tarball"
	exit 0
    fi
}

function rooting()
{
    # backup default.prop
    adb pull /default.prop default.prop.orig
    # pushing new default.prop for rooting purpose
    echo "pushing default.prop"
    adb push default.prop /
    # 
    echo "pushing flag to /"
    echo "1" > flag
    adb push flag /
    echo "STEP 1/7"
    echo " "
    echo "TURNING OFF..."
    echo "PLEASE TURN ON THE DEVICE AND RE-RUN THIS SCRIPT USING THE COMMAND: bash install.sh <IP-Address>"
    echo "Press ctrl+c now"
    adb reboot
}

function installing()
{
    #pushing aakash.sh for chroot, mounting, and apache2
    adb push $AAKASH $DEV_PATH
    adb shell chmod 777 ${DEV_PATH}${AAKASH}
    echo "STEP 2/7"
    sleep 0.2

    # init.rc
    adb push init.rc /
    echo "STEP 3/7"
    sleep 0.2

    echo "Copying tarball... this might take more than 15 minutes"
    adb push $TAR_FILE $DEV_PATH
    echo "STEP 4/7"
    
    # push binary tar, and change the permissions
    adb push tar $DEV_PATH
    adb shell chmod 777 ${DEV_PATH}tar
    echo "STEP 5/7"    

    echo "untar the tarball, again this will take some time (15minutes)"
    adb shell ${DEV_PATH}tar -xvpzf ${DEV_PATH}${TAR_FILE} -C $DEV_PATH
    echo "STEP 6/7"

    # remove previous installed apk if any
    adb uninstall $UNINSTALL_APK
    
    # install all apks available in current working directory
    adb install -r $APK
    echo "STEP 7/7 : all done "

    echo "cleaning up ..."
    adb shell rm /flag
    adb shell rm ${DEV_PATH}${TAR_FILE}

    # unrooting
    adb push default.prop.orig /default.prop
    rm -f default.prop.orig
    
    sleep 1
    echo "THE SYSTEM WILL SHUTDOWN AUTOMATICALLY NOW"
    echo "PLEASE TURN ON THE DEVICE MANUALLY"
    echo "HIT CTRL+c now"
    sleep 5
    adb reboot
}

function connect_device()
{
    local ADB_DEVICES=0
    sanity_check    
    # try to connect to device, loop till the device gets connected
    while [ $ADB_DEVICES -le 2 ]
    do
	adb kill-server
	adb start-server
	echo "connecting to device at IP: $IP"
	adb connect $IP
	ADB_DEVICES=$(adb devices | wc -l)
    done

    FLAG=$(adb shell cat /flag | tr -d '\r')
    # echo $FLAG
    ANS=1
    
    if [ "$FLAG" == "$ANS" ];
    then
        # echo $FLAG
	echo "installing"
    	installing	
    else
	rooting
    fi
}

# __init__
if [ "$ARG_COUNT" -ne 1 ];
then
    echo "Usage: $0 <IP-address>"
    exit 0
else
    connect_device
fi

