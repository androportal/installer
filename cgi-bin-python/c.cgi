#!/usr/bin/python
import json
import cgi
import cgitb; cgitb.enable()
from os import path, system, sys
from time import sleep
from sys import exit
from subprocess import Popen, PIPE
from functions import *

checkScript = "pgrep c.cgi|wc -l"
returnVal = Popen(checkScript,shell=True, stdout=PIPE).stdout.read().strip('\n')
if int(returnVal) > 1:
    system("killall c.cgi")
    exit()

sourceFile = '/tmp/1.c'
saveSourceFile = '/tmp/saveC.c'

print "Content-type: text/html\n\n"
print 

form = cgi.FieldStorage()
code = form.getvalue('code')
filename1 = form.getvalue('filename1')
flag_save1 = form.getvalue('flag_save1')

###################################################################

if int(flag_save1) is 1:
    writeCode(saveSourceFile,str(code))
    system("cp %s /tmp/csave/%s.c" %(saveSourceFile, filename1))
    system("touch /var/www/html/saveflag")
    system("rm %s" %(saveSourceFile))
    exit()	
else:
    killnRemoveExcept('c.cgi')
    writeCode(sourceFile,str(code))
    system("gcc -w %s -o /tmp/cbin 2> /tmp/cerror" %(sourceFile))

###################################################################

while(True):
	if path.exists('/var/www/html/flag'):
		sleep(0.2)
		results={"output":""}
		print json.dumps(results)
		system("rm /var/www/html/flag")
		exit()  

