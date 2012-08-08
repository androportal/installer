#!/usr/bin/python
import json
import cgi
import cgitb; cgitb.enable()
from os import path, system, sys, setuid
from time import sleep
from sys import exit
from subprocess import Popen
from functions import *

checkScript = "pgrep scilab.py|wc -l"
returnVal = Popen(checkScript,shell=True, stdout=PIPE).stdout.read().strip('\n')
if int(returnVal) > 1:
#    system("killall scilab.py")
    exit()

sourceFile     = '/var/www/html/scilab/tmp/1.cde'
sourceFilePlot = '/var/www/html/scilab/tmp/plot.cde'
saveSourceFile     = '/var/www/html/scilab/tmp/nogui.cde'
saveSourceFilePlot = '/var/www/html/scilab/tmp/gui.cde'
errorFile      = '/var/www/html/scilab/tmp/1.err'
imagePath      = '/var/www/html/scilab/tmp/1.gif'

form         = cgi.FieldStorage()
code         = form.getvalue('code')
filename1    = form.getvalue('filename1')
filename     = form.getvalue('filename')
flag_save1   = form.getvalue('flag_save1')
flag_save    = form.getvalue('flag_save')
graphicsmode = form.getvalue('graphicsmode')

print "Content-type: text/html\n\n"
print 

####################################################################

if int(flag_save) is 1:
    system("cp %s /tmp/scisaveimg/%s.gif" %(imagePath, filename))
    system("touch /var/www/html/saveflag")
    system("rm %s" %(imagePath))
    exit()	

if int(graphicsmode) is 0:
    if int(flag_save1):
        SaveCode(str(code),saveSourceFile,filename1)
        exit()
    else:
        killnRemoveExcept('scilab.py')
        writeNoGUIcode(str(code),sourceFile)

elif int(graphicsmode) is 1:
    if int(flag_save1):
        SaveCode(str(code),saveSourceFilePlot,filename1)
        exit()
    else:
        killnRemoveExcept('scilab.py')
        writeGUIcode(str(code),sourceFilePlot)
        system("scilab -nb -f %s" %(sourceFilePlot))
        system("touch /var/www/html/flag")

#####################################################################
"""
while(True):
	if path.exists('/var/www/html/flag'):
            sleep(0.2)
            if int(graphicsmode):
                if path.exists(errorFile):
		    results={"output":""}
		else:
                    results={"output":"", "image":1}
            else:
                results={"output":""}
            print json.dumps(results)
            system("rm /var/www/html/flag")
            system("killall scilex")
            exit()  
"""            
while(True):
    if path.exists('/var/www/html/flag'):
        sleep(0.4)
        if int(graphicsmode):
            if path.exists(errorFile):
	        results={"output":""}
	    else:
                results={"output":"", "image":1}
        else:
            results={"output":""}
        print json.dumps(results)
        system("rm /var/www/html/flag")
        system("killall scilex")
        exit()  
            
