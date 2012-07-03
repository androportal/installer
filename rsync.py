#!/usr/bin/python 

from subprocess import Popen, PIPE
from time import sleep
from os import path, mkdir, system

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

for eachList in allSavePaths, allCodePaths:
    for thatDir in eachList:
        if not path.isdir(thatDir):
            mkdir(thatDir)

while True:
    for each in range(0, len(allSavePaths)):
        rsync = 'rsync -r %s/* %s' %(allSavePaths[each],allCodePaths[each])	
        Popen(rsync,shell=True, stdout=PIPE)
    sleep(3) 
