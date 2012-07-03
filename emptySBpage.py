from commands import getstatusoutput
from os import system
from subprocess import Popen, PIPE
from time import sleep

allURLs = ['/html/c/index.html',
           '/html/cpp/index.html',
           '/html/python/index.html',
           '/html/scilab/index.html']

grepCommand = "tail -1 /var/log/apache2/access.log|rgrep "
commonCommand = 'shellinaboxd --localhost-only -t -s /:www-data:www-data:/:'
previousPage = ''
while True:
    sleep(0.2)
    SBcommand = commonCommand + 'true'
    for thisURL in allURLs:
        ExitStatus = getstatusoutput(grepCommand + thisURL)
        print ExitStatus
        if ExitStatus[0] is 0 and previousPage is not thisURL:
             system("killall -s 9 shellinaboxd")
             Popen(SBcommand,shell=True, stdout=PIPE)
             print "rum shellinabox for ", thisURL
             previousPage = thisURL
             break
