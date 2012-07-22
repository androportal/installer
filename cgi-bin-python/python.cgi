#!/usr/bin/python
import json
import cgi
import cgitb; cgitb.enable()
from os import path, system, sys
from time import sleep
from sys import exit
from subprocess import Popen, PIPE

checkScript = "pgrep python.cgi|wc -l"
returnVal = Popen(checkScript,shell=True, stdout=PIPE).stdout.read().strip('\n')
if int(returnVal) > 1:
	exit()

system("rm /tmp/1.* /tmp/*error /tmp/*bin /var/www/html/flag")
system("rm /var/www/html/scilab/tmp/*")
system("killall -s INT c.cgi");
system("killall -s INT scilab.cgi");
system("killall -s INT cpp.cgi");

sourceFile = '/tmp/1.py'

print "Content-type: text/html\n\n"
print 

form = cgi.FieldStorage()
code = form.getvalue('code')
filename1 = form.getvalue('filename1')
flag_save1 = form.getvalue('flag_save1')

def writeCode(sourceFile):
    f = open(sourceFile,'w')
    f.write(code)
    f.close()

writeCode(sourceFile)
    
if int(flag_save1) is 1:
    system("cp %s /tmp/pysave/%s.c" %(sourceFile, filename1))
    exit()	

while(True):
	if path.exists('/var/www/html/flag'):
		sleep(0.2)
		results={"output":""}
		print json.dumps(results)
		system("rm /var/www/html/flag")
		exit()  

