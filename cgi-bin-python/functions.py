#!/usr/bin/python
from os import path, system, sys, setuid
from time import sleep
from sys import exit
from subprocess import Popen, PIPE

kill   = ['cbin', 'c.cgi',
          'cpbin', 'cpp.cgi',
          'python.cgi',
          'scilex', 'scilab.cgi']

remove = ['/tmp/1.c', '/tmp/cerror', '/tmp/cbin',
          '/tmp/1.cpp', '/tmp/cperror', '/tmp/cpbin',
          '/tmp/1.py',
          '/var/www/html/scilab/tmp/1.cde', '/var/www/html/scilab/tmp/1.err',
          '/var/www/html/scilab/tmp/plot.cde'
          '/var/www/html/flag']


def killnRemoveExcept(presentCGI):
    kill.remove(presentCGI)
    for each in kill:
        system("killall %s" %(each))
    for each in remove:
        system("rm %s" %(each))

def writeCode(sourceFile,code):
    f = open(sourceFile,'w')
    f.write(code)
    f.close()
    
def writeNoGUIcode(code,sourceFile):
    f = open(sourceFile,'w')
    f.write("mode(-1);\nlines(0);\nmode(-1);\ntry\nmode(2);\n")
    f.write(code)
    f.write("\nmode(-1);\nexit();\ncatch\nmode(-1);\ndisp(lasterror());\nexit();")
    f.close()


def writeGUIcode(code,sourceFilePlot):
    f = open(sourceFilePlot,'w')
    f.write("mode(-1);\ntry\nscf(0);\n")
    f.write(code)
    f.write("\nmode(-1);\nxs2gif(0,\'/var/www/html/scilab/tmp/1.gif\');")
    f.write("\nexit();\ncatch\n[error_message,error_number]=lasterror(%t);\n")
    f.write("ukm=file(\'open\',\'/var/www/html/scilab/tmp/1.err\');")
    f.write("\nwrite(ukm,error_message);\nfile(\'close\',ukm);\n")
    f.write("xdel(winsid());\nend;\nexit();")
    f.close()


def SaveCode(code,source,request):
    """ 
    writes CM's content to file and copies it to SDCARD
    """
    f = open(source,'w')
    f.write(code)
    f.close()
    system("cp %s /tmp/scisave/%s.cde" %(source,request))
    system("touch /var/www/html/saveflag")
    system("rm %s" %(source))
