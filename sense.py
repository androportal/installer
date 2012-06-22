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

"""
Add code here to check whether .example.option is available or not.
"""
previousTimeStamp = [1.0]
system('rm /tmp/cperror /tmp/cerror /tmp/*bin /tmp/1.py')

def returnCommand():
    allPaths = ['/tmp/cbin', '/tmp/cerror', '/tmp/cpbin', '/tmp/cperror', '/tmp/1.py']
    commonCommand = 'shellinaboxd --localhost-only -t -s /:www-data:www-data:/:'
    for checkPath in allPaths:
        sleep(0.5)
        if(path.isfile(checkPath)):
            if(checkPath == allPaths[0] or checkPath == allPaths[2]):
                command = commonCommand + '%s' %(checkPath)
                #used -w option in c and cpp to avoid warnings
                break
            elif(checkPath == allPaths[1] or checkPath == allPaths[3]):
                command = commonCommand + "'cat %s'" %(checkPath)
                break 
            elif(checkPath == allPaths[4]):
                command = commonCommand + "'python %s'" %(checkPath)
                #Python executes in any condition, back, forward
                break
        else:
            command = commonCommand + 'true'
            checkPath = None
    return command,checkPath

def executeCommand():
    SBcommand, pathAvailable = returnCommand()
    if (previousTimeStamp[0] == 1.0) and (pathAvailable == None):
        system("killall -s 9 shellinaboxd")
        Popen(SBcommand,shell=True, stdout=PIPE)
        print "I am in first time execution",previousTimeStamp
        sleep(0.5)

    elif(previousTimeStamp[0] != path.getmtime(pathAvailable)):
        system("killall -s 9 shellinaboxd")
        Popen(SBcommand,shell=True, stdout=PIPE)
        print SBcommand, previousTimeStamp
        previousTimeStamp[0] = path.getmtime(pathAvailable)
        print previousTimeStamp
        sleep(0.5)
    
    
while True:
    executeCommand()
