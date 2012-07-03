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
from commands import getstatusoutput

#Default time stamp at boot time
previousTimeStamp = [1.0]
system('rm /tmp/cperror /tmp/cerror /tmp/*bin /tmp/1.py /tmp/1.cde')

commonCommand = 'shellinaboxd --localhost-only -t -s /:www-data:www-data:/:'
grepCommand   = "tail -1 /var/log/apache2/access.log|rgrep "

allPaths = ['/tmp/cbin',
            '/tmp/cerror',
            '/tmp/cpbin', 
            '/tmp/cperror',
            '/tmp/1.py',
            '/tmp/1.cde']



allURLs = ['/html/c/index.html',
           '/html/cpp/index.html',
           '/html/python/index.html',
           '/html/scilab/index.html']

"""
The function below is used to clear the SB page when user switches from 
one programming env to other.
"""
def checkURL():
    previousPage = ''
    sleep(1)
    SBcommand = commonCommand + 'true'
    for thisURL in allURLs:
        ExitStatus = getstatusoutput(grepCommand + thisURL)
        if ExitStatus[0] is 0 and previousPage is not thisURL:
            system("killall -s 9 shellinaboxd")
            Popen(SBcommand,shell=True, stdout=PIPE)
            print "rum shellinabox for ", thisURL
            previousPage = thisURL
            break
            


def returnCommand():
    for checkPath in allPaths:
        sleep(1)
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
            elif(checkPath == allPaths[5]):
                command = commonCommand + "'/usr/lib/scilab-4.1.1/bin/scilex -nogui -nb -ns -f %s'" %(checkPath)
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
#        sleep(0.4)
        Popen(blankCommand,shell=True, stdout=PIPE)
        print "I am in first time execution",previousTimeStamp
        #break
    elif((previousTimeStamp[0] != path.getmtime(pathAvailable)) and (pathAvailable in allPaths)):
        system("killall -s 9 shellinaboxd")
 #       sleep(0.4)
        Popen(SBcommand,shell=True, stdout=PIPE)
        system("touch /var/www/html/flag")
        system("chown www-data.www-data /var/www/html/flag")
        print SBcommand, previousTimeStamp
        previousTimeStamp[0] = path.getmtime(pathAvailable)
        #break    


while True:
 #   print 'before 1'
    executeCommand()
#    print 'after 1 before 2'
#    checkURL()
  #  print 'after 2'

