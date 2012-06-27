#!/usr/bin/python 
"""
An extra wrapper code to execute/show binaries/errors genrerated from perl CGI scripts.
The reason of this extra script is to execute 'shellinaboxd' as its not working
within the apache hosted CGI for unknown reasons. The same CGI scripts work well without
this python script in 12.04 desktop version. 
"""
from os   import path, system
from time import sleep
from subprocess import Popen, PIPE

#Default time stamp at boot time
previousTimeStamp = [1.0]
system('rm /tmp/cperror /tmp/cerror /tmp/*bin /tmp/1.py')

commonCommand = 'shellinaboxd --localhost-only -t -s /:www-data:www-data:/:'
allPaths = ['/tmp/cbin', '/tmp/cerror', '/tmp/cpbin', '/tmp/cperror', '/tmp/1.py']


def returnCommand():
    for checkPath in allPaths:
        sleep(0.2)
        if(path.isfile(checkPath)):
            if((checkPath == allPaths[0]) or (checkPath == allPaths[2])):
                command = commonCommand + '%s' %(checkPath)
                #used -w option in c and cpp to avoid warnings
                break
            elif(((checkPath == allPaths[1] or checkPath == allPaths[3])) and (path.getsize(checkPath))):
                command = commonCommand + "'cat %s'" %(checkPath)
                break 
            elif(checkPath == allPaths[4]):
                command = commonCommand + "'python %s'" %(checkPath)
                #Python executes in any condition, back, forward
                break

        else:
            command = ''
            checkPath = '/root/sb_manage.py'
    return command,checkPath

def executeCommand():
    SBcommand, pathAvailable = returnCommand()
    if (previousTimeStamp[0] == 1.0) and (pathAvailable not in allPaths):
        system("killall -s 9 shellinaboxd")
        blankCommand = 'shellinaboxd --localhost-only -t -s /:www-data:www-data:/:true'
        Popen(blankCommand,shell=True, stdout=PIPE)
        print "I am in first time execution",previousTimeStamp

    elif((previousTimeStamp[0] != path.getmtime(pathAvailable)) and (pathAvailable in allPaths)):
        system("killall -s 9 shellinaboxd")
        Popen(SBcommand,shell=True, stdout=PIPE)
        system("touch /var/www/html/flag")
        system("chown www-data.www-data /var/www/html/flag")
        print SBcommand, previousTimeStamp
        previousTimeStamp[0] = path.getmtime(pathAvailable)
    
while True:
    executeCommand()
