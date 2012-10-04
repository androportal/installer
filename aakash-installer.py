#!/usr/bin/python

import os
import csv
import time
from subprocess import Popen, PIPE


mac_cmd = "sudo adb shell ip link show wlan0 | busybox awk '/ether/ {print $2}'"
adb_cmd = "sudo adb get-state"
ftp_addr = " ftp://127.0.0.1/aakash/ "
curlftpfs_mount_dir = " /mnt/aakash "
curlftpfs_cmd = "sudo curlftpfs " + ftp_addr + curlftpfs_mount_dir
rsync_dest_dir = " ~/Desktop/ "
rsync_cmd = "sudo rsync -ra --delete " + curlftpfs_mount_dir + rsync_dest_dir
umount_dir = "sudo umount " + curlftpfs_mount_dir
# unset proxy didn't work, need to find some better solution
unset_proxy = "unset http_proxy https_proxy ftp_proxy"

""" 
The below 'list_of_apk_dirs' should present inside ftp://server-ip/ with given
file hirarchy and each should contain subdir as 'apk' and 'data' if any.

Programmer must provide a file named 'path' in 'data' directory which should 
contain the comma separated source and destination path for each file.

For example, let us take 'ftp://server-ip/aakash/apl/data/' which suppose contain
2 files aakash.sh and preinstall.sh. These files to be pushed in different 
directories in aakash. To do so, create a plain text file name 'path' in '/apl/data/'
which should contain only two comma separated entries. Such as,

aakash.sh, /data/local
preinstall.sh, /system/bin/

NOTE: Replace file name with directory name in case you want to push directory.

Never ever change local (~/Desktop/aakash/) directory or files manually.
"""

list_of_apk_dirs = ['aakash/clicker/apk',
                    'aakash/proximity/apk',
                    'aakash/blender/apk', 
                    'aakash/apl/apk', 
                    'aakash/others/apk']


list_of_data_dirs = ['aakash/clicker/data',
                     'aakash/proximity/data',
                     'aakash/blender/data', 
                     'aakash/apl/data', 
                     'aakash/others/data']


def headerText():
    os.system('clear')
    print '\n'
    print '----------------------------------------------------------'
    print '|      Aakash  Installation  Log     (Version 0.1)       |' 
    print '----------------------------------------------------------\n\n'


def statusText():
    print "\t     ------------------------------"
    print "\t     |  Aakash device connected   |"
    print "\t     ------------------------------\n"



def getStdout(command):
    return Popen(command, shell=True, stdout=PIPE).stdout.read().strip('\n')


def rsyncWithServer():
    print "-->  Contacting %s for any update" %(ftp_addr) +'\n'
    os.system(unset_proxy)
    os.system("mkdir %s %s &> /dev/null" %(curlftpfs_mount_dir, rsync_dest_dir))
    # A test must be done whether ftp is running or not, if not rsync should not take place
    # as it will remove the destination directory
    os.system(curlftpfs_cmd)
    os.system(rsync_cmd)
    os.system(umount_dir)
    os.system('sync')
    print "-->  Syncing with server done, all latest apps present in ~/Desktop/aakash/ \n"
    time.sleep(4)


def installAPKs():
    # converting relative paths to absolute for present user
    fullPathofAPK = []
    for eachdir in list_of_apk_dirs:
        fullPathofAPK.append(os.getenv('HOME') + '/Desktop/' + eachdir)
    for eachFullPath in fullPathofAPK:
        if os.path.isdir(eachFullPath):
            os.chdir(eachFullPath)
            print "\n\nInstalling apks from :  %s" %(eachFullPath)
            print "----------------------\n"
            for apks in os.listdir("."):
                if apks.endswith(".apk"):
                    if os.system("sudo adb install -r %s &> /dev/null" %(apks)):
                        print "-->  Can't install %s, please check if\
                               device is connected properly\n" %(apks)
                    else:
                        print "-->  Installed successfully %s\n" %(apks)



def pushData():
    fullPathofData = []
    for eachdir in list_of_data_dirs:
        fullPathofData.append(os.getenv('HOME') + '/Desktop/' + eachdir)
    for eachDataPath in fullPathofData:
        if os.path.isdir(eachDataPath):
            os.chdir(eachDataPath)
            print "\n\nPushing data from :  %s" %(eachDataPath)
            print "------------------\n"
            if os.path.isfile('path'):
                reader = csv.reader(open('path', 'r'))
                for row in reader:
                    if os.system("sudo adb push %s &> /dev/null" %('\t'.join(row))):
                        print "-->  Can't push file to destination, please check\
                                    if device is connected properly\n"
                    else:
                        print "-->  Pushed %s successfully\n" %('\t'.join(row))





def checkDeviceMacAddress():
    mac_addr = getStdout(mac_cmd)
    if int(len(mac_addr)) is 17:
        headerText()
        statusText()
        print '-->  MAC address of the device :  ' + mac_addr + '\n'
    else:
        headerText()
        statusText()
        print '-->  **NOTE :  To view MAC address of the device just enable WiFi in Aakash,'
        print '          connection to WiFi is not required.\n'


def detectDevice():
    while True:
        time.sleep(0.5)
        if 'device' in getStdout(adb_cmd):
            break    
        else:
            headerText()
            print "      ------------------------------------------"
            print "      |        *** NO DEVICE FOUND ***         |"
            print "      | Connect aakash and wait for 10 seconds |"
            print "      ------------------------------------------"


if __name__=="__main__":
    detectDevice()
    checkDeviceMacAddress()
    rsyncWithServer()
    installAPKs()
    pushData()
    
