#!/usr/bin/python 
"""
An extra wrapper code to execute/show binaries/errors genrerated from perl CGI scripts.
The reason of this extra script is to execute 'shellinaboxd' as its not working
within the apache hosted CGI for unknown reasons. The same CGI scripts work well without
this python script in 12.04 desktop version. 
"""

from os   import path, system, mkdir
from time import sleep
from subprocess import Popen, PIPE
from commands import getstatusoutput
import json
import signal

#Default time stamp at boot time
previousTimeStamp = [1.0]

system('rm /tmp/cperror /tmp/cerror /tmp/*bin /tmp/1.py /var/www/html/scilab/tmp/*')

commonCommand = 'shellinaboxd --localhost-only -t -s /:www-data:www-data:/:'
blankCommand  = 'shellinaboxd --localhost-only -t -s /:www-data:www-data:/:true'
grepCommand   = "tail -1 /var/log/apache2/access.log|rgrep "
findSB        = 'ps -eo pid,args | grep shellinaboxd | grep -v grep|tail -n1'

allPaths     = ['/tmp/cbin',
                '/tmp/cerror',
                '/tmp/cpbin', 
                '/tmp/cperror',
                '/tmp/1.py',
                '/var/www/html/scilab/tmp/1.err',
                '/var/www/html/scilab/tmp/1.cde']

allSavePaths = ['/tmp/csave',
                '/tmp/cpsave',
                '/tmp/pysave', 
                '/tmp/scisave',
                '/tmp/scisaveimg']

allCodePaths = ['/var/www/html/c/code',
                '/var/www/html/cpp/code',
                '/var/www/html/python/code',
                '/var/www/html/scilab/code',
                '/var/www/html/scilab/image']

system("touch /var/www/html/c/exbind/.open_file.c && chmod 777 -R /var/www/html/c/exbind/")
system("touch /var/www/html/cpp/exbind/.open_file.cpp && chmod 777 -R /var/www/html/cpp/exbind/")
system("touch /var/www/html/python/exbind/.open_file.py && chmod 777 -R /var/www/html/python/exbind/")
system("touch /var/www/html/scilab/exbind/.open_file.cde && chmod 777 -R /var/www/html/scilab/exbind/")

guiCodePath = '/var/www/html/scilab/tmp/plot.cde'

for eachList in allSavePaths, allCodePaths:
    for thatDir in eachList:
        if not path.isdir(thatDir):
            mkdir(thatDir)

def cp():
    for each in range(0, len(allSavePaths)):
        copy = 'cp -r %s/* %s' %(allSavePaths[each],allCodePaths[each])	
        Popen(copy,shell=True, stdout=PIPE)



def returnCommand():
    for checkPath in allPaths:
        sleep(0.6)
        if(path.isfile(checkPath)):
            if((checkPath == allPaths[0]) or (checkPath == allPaths[2])):
                command = commonCommand + '%s' %(checkPath)
                #used -w option in c and cpp to avoid warnings
                break
            elif(((checkPath == allPaths[1] or checkPath == allPaths[3] or checkPath == allPaths[5])) and (path.getsize(checkPath))):
                command = commonCommand + "'cat %s'" %(checkPath)
                break 
            elif(checkPath == allPaths[4]):
                command = commonCommand + "'python %s'" %(checkPath)
                break
            elif((checkPath == allPaths[6]) and path.getsize(checkPath)):
                command = commonCommand + "'/scilab-5.4.minimal/bin/scilab -nogui -nb -f %s'" %(checkPath)
                break
            #elif(checkPath == allPaths[7]):
             #   command = ''
              #  checkPath = '/root/sb_manage.py'
               # break
                
        else:
            command = ''
            checkPath = '/root/sb_manage.py'    
    return command,checkPath

def checkSBemptyPageRunning():
    presentSB = Popen(findSB, shell=True, stdout=PIPE).stdout.read().strip('\n')
    if blankCommand in presentSB:
        return False
    else:
        return True


def executeCommand():
    SBcommand, pathAvailable = returnCommand()

    if((previousTimeStamp[0] != path.getmtime(pathAvailable)) and (pathAvailable in allPaths)):
        system("killall -s 9 shellinaboxd")
        sleep(0.3)
        Popen(SBcommand,shell=True, stdout=PIPE)
        system("touch /var/www/html/flag")
        system("chown www-data.www-data /var/www/html/flag")
        previousTimeStamp[0] = path.getmtime(pathAvailable)
        print pathAvailable,previousTimeStamp[0]

    if(path.isfile("/var/www/html/saveflag")):
        cp()
        system("rm /var/www/html/saveflag")

    #elif((pathAvailable not in allPaths) and checkSBemptyPageRunning()):
    if(path.isfile(guiCodePath) and (pathAvailable not in allPaths) and checkSBemptyPageRunning()):
        system("killall -s 9 shellinaboxd")
        sleep(0.2)
        Popen(blankCommand,shell=True, stdout=PIPE)
        print "i'm in scilab gui no sb page running place"
        print pathAvailable


while True:
    executeCommand()
