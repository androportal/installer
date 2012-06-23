#!/system/bin/sh

export bin=/system/bin
export PATH=$bin:/usr/bin:/usr/sbin:/bin:$PATH
export TERM=linux
export HOME=/root
export MNT=/data/local/linux

export SDCARD=/mnt/sdcard/APL
export WWW=/data/local/linux/var/www/html

FLAG=1

while [ $FLAG -eq 1 ]
do
    
    while [ $(pgrep com.aakash.lab | wc -l) -eq 1 ]
    do
	
	if [ ! -d ${SDCARD} ] && [ ! -d ${WWW} ]
	then                                                                  
	    mkdir -p ${SDCARD}/c/code                                         
	    mkdir -p ${WWW}/c/code                                            
	    
	    mkdir -p ${SDCARD}/cpp/code                                       
	    mkdir -p ${WWW}/cpp/code                                          
	    
	    mkdir -p ${SDCARD}/python/code                                     
	    mkdir -p ${WWW}/python/code     
	    
	    mkdir -p ${SDCARD}/scilab/code
	    mkdir -p ${WWW}/scilab/code   
	    
	    mkdir -p ${SDCARD}/scilab/image
	    mkdir -p ${WWW}/scilab/image   
	fi

    sleep 0.5

	busybox mount -o bind ${SDCARD}/c/code ${WWW}/c/code
	busybox mount -o bind ${SDCARD}/cpp/code ${WWW}/cpp/code
	busybox mount -o bind ${SDCARD}/python/code ${WWW}/python/code
	busybox mount -o bind ${SDCARD}/scilab/code ${WWW}/scilab/code
	busybox mount -o bind ${SDCARD}/scilab/image ${WWW}/scilab/image

	busybox  chroot  /data/local/linux /bin/bash -c "nohup python /root/rsync.py &>'/dev/null'&"

	FLAG=0
    exit 0 
    done
sleep 5 
done

exit 0

