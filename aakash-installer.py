#!/usr/bin/python

import os
import csv
import sys
import time
from subprocess import Popen, PIPE


mac_cmd = "sudo adb shell ip link show wlan0 | busybox awk '/ether/ {print $2}'"
adb_cmd = "sudo adb get-state"
ftp_addr = " ftp://127.0.0.1/aakash/ "
curlftpfs_mount_dir = " /mnt/aakash "
curlftpfs_cmd = "sudo curlftpfs " + ftp_addr + curlftpfs_mount_dir + " &> /dev/null"
rsync_dest_dir = " ~/Desktop/ "
rsync_cmd = "sudo rsync -ra --delete " + curlftpfs_mount_dir + rsync_dest_dir
umount_dir = "sudo umount " + curlftpfs_mount_dir + " &> /dev/null"
# unset proxy didn't work, need to find some better solution
unset_proxy = "unset http_proxy https_proxy ftp_proxy"


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


def help():
    os.system('cat /usr/share/aakash/help.txt')
   

def getStdout(command):
    return Popen(command, shell=True, stdout=PIPE).stdout.read().strip('\n')


def rsyncWithServer():
    print "-->  Contacting %s for any update" %(ftp_addr) +'\n'
    os.system(unset_proxy)
    os.system(umount_dir)  # Just in case if some thing is already mounted
    os.system("mkdir %s %s &> /dev/null" %(curlftpfs_mount_dir, rsync_dest_dir))
    # A test must be done whether ftp is running or not, if not rsync should not take place
    # as it will remove the destination directory
    if os.system(curlftpfs_cmd):
        print "Error connecting to ftp server, please check your connection."
        print "If you are very sure that there is nothing to sync from server and you want to "
        print "force install the apps then use 'aakash' with '-f'(force install) flag:\n"
        print "$ aakash -f"
        sys.exit(0)
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


def checkAndroidDirExistenceIfNotCreate(path):
    # As 'path' is full path so need to separate source & destination
    path[-1]


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
                    # Must create dir if not present (make it default way)
                    checkAndroidDirExistenceIfNotCreate(row)
                    if os.system("sudo adb push %s &> /dev/null" %('\t'.join(row))):
                        print "-->  Can't push file to destination, please check\
                                    if device is connected properly\n"
                    else:
                        print "-->  Pushed %s to %s successfully \n" %(row[0], row[1])



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


def executeAll(*exceptThese):
    listFunctions = ['detectDevice()', 'checkDeviceMacAddress()',
                     'rsyncWithServer()', 'installAPKs()', 'pushData()']
    exceptThese = list(exceptThese)
    print exceptThese
    if len(exceptThese) is 0:
        for eachFunction in listFunctions:
            exec(eachFunction)
    else:
        for eachSkipFunction in exceptThese:
            listFunctions.remove(eachSkipFunction)                            
        for eachFunction in listFunctions:
            exec(eachFunction)



if __name__=="__main__":
    args = sys.argv
    if '-f' in args:
        executeAll('rsyncWithServer()')
    elif '-m' in args:
        executeAll('rsyncWithServer()','installAPKs()', 'pushData()')
    elif '-a' in args:
        executeAll('pushData()')
    elif '-h' in args:
        help()
    elif '-hb' in args:
        if int(len(args)) is 2:
            os.system("%s /usr/share/aakash/help.html" %(args[args.index('-hb') + 1]))
        else:
            print "Missing browser name. Example:"
            print "   $ aakash -hb firefox"
    elif int(len(args)) is 1:
        executeAll()
    else:
        print "Wrong option. Please see help(-h)"
        print "   $ aakash -h"

