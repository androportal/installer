#!/usr/bin/python
import json
import cgi
import cgitb; cgitb.enable()
from os import path, system, sys
from time import sleep
from sys import exit
from subprocess import Popen, PIPE

checkScript = "pgrep c.cgi|wc -l"
returnVal = Popen(checkScript,shell=True, stdout=PIPE).stdout.read().strip('\n')
if int(returnVal) > 1:
	exit()

system("rm /tmp/1.* /tmp/*error /tmp/*bin /var/www/html/flag")
system("rm /var/www/html/scilab/tmp/*")
system("killall -s INT python.cgi");
system("killall -s INT scilab.cgi");
system("killall -s INT cpp.cgi");

sourceFile = '/tmp/1.c'

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
    system("cp %s /tmp/csave/%s.c" %(sourceFile, filename1))
    exit()	

if int(flag_save1) is not 1:
 	system("gcc -w %s -o /tmp/cbin 2> /tmp/cerror" %(sourceFile))

while(True):
	if path.exists('/var/www/html/flag'):
		sleep(0.2)
		results={"output":""}
		print json.dumps(results)
		system("rm /var/www/html/flag")
		exit()  

#results={"output":"", "image":0, "imagefile":"", "error":"error"}
