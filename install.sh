#!/bin/bash

# ---- global variable ----
declare ARG_COUNT=$#
declare IP=$1

declare TAR_FILE="linux.tar.gz"
declare UNINSTALL_APK="com.aakash.lab"
declare APK="*.apk"
declare AAKASH="aakash.sh"

declare DEV_PATH="/data/local/"
declare BIN_PATH="/system/xbin/"
declare MD5GEN=$(md5sum $TAR_FILE | cut -d " " -f 1 -)
declare MD5FILE=$(cat MD5CHECK | cut -d " " -f 1 -)
declare SET_DATE=$(date +%Y.%m.%d-%H:%M:%S)
# -------------------------

function valid_ip()
{
    # ref: http://www.linuxjournal.com/content/validating-ip-address-bash-script

    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
	IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    if [ $stat -ne 0 ];
	then
	echo "invalid IP-Address: $IP"
	exit 0
    fi
}

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

#    elif [ ! -f APL_v2.apk ];
 #   then
#	echo "APL_v2.apk: not found"
#	exit 0

    elif [ ! -f rsync ];
    then
	echo "binary 'rsync': not found"
	exit 0

    elif [ ! -f rsync.py ];
    then
	echo "rsync.py: not found"
	exit 0

    elif [ ! -f bind.sh ];
    then
	echo "bind.sh: not found"
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

    echo "pushing flag to /"
    echo "1" > flag
    sleep 2 
    adb push flag /
    sleep 1
    echo "pushing default.prop"
    adb push default.prop /
    sleep 1
    
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
    adb push bind.sh $DEV_PATH
    adb shell chmod 777 ${DEV_PATH}${AAKASH}
    adb shell chmod 777 ${DEV_PATH}bind.sh
    echo "STEP 2/7"
    sleep 0.2

    # syncronise device's time with system's time
    adb shell busybox date -s ${SET_DATE}

    # init.rc
    adb push init.rc /
    echo "STEP 3/7"
    sleep 0.2

    echo "Copying tarball... this might take more than 15 minutes"
    adb push $TAR_FILE $DEV_PATH
    echo "STEP 4/7"
    
    # push binary tar, rsync, bash, and change the permissions
    adb push tar $DEV_PATH

    adb push bash $BIN_PATH

    adb shell chmod 777 ${DEV_PATH}tar

    adb shell chmod 777 ${BIN_PATH}bash
    echo "STEP 5/7"    

    echo "untar the tarball, again this will take some time (15minutes)"
    adb shell ${DEV_PATH}tar -xvpzf ${DEV_PATH}${TAR_FILE} -C $DEV_PATH

    adb push rsync ${DEV_PATH}linux/usr/bin/
    adb shell chmod 777 ${DEV_PATH}linux/usr/bin/rsync
    adb push rsync.py ${DEV_PATH}linux/var/www/html/
    adb push sb_manage.py ${DEV_PATH}linux/var/www/html/
    echo "STEP 6/7"

    # remove previous installed apk if any
    adb uninstall $UNINSTALL_APK
    
    # install all apks available in current working directory
    adb install -r $APK
    echo "STEP 7/7 : all done "

    # syncronise device's time with system's time
    adb shell date -s ${SET_DATE}

    echo "cleaning up ..."
   # adb shell rm /flag
    adb shell rm ${DEV_PATH}${TAR_FILE}

    # unrooting
    sleep 1
#    adb push default.prop.orig /default.prop
    sleep 0.2
    rm -f default.prop.orig
    rm -f flag

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

    FLAG_CHECK=$(adb shell cat /flag | tr -d '\r')
    # echo $FLAG
    ANS=1
    
    if [ "$FLAG_CHECK" == "$ANS" ];
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
    valid_ip $IP
    connect_device
fi

