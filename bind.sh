#!/system/bin/sh

export SDCARD=/mnt/sdcard/APL
export WWW=/data/local/linux/var/www/html

while true;
    do 
        if [ -n "$(pgrep com.aakash.lab)" ] #True if length of string is non zero
            then
                if [ ! -d ${SDCARD} ] || [ ! -d ${WWW} ]
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
            busybox mount -o bind ${SDCARD}/c/code ${WWW}/c/code
            busybox mount -o bind ${SDCARD}/cpp/code ${WWW}/cpp/code
            busybox mount -o bind ${SDCARD}/python/code ${WWW}/python/code
            busybox mount -o bind ${SDCARD}/scilab/code ${WWW}/scilab/code
            busybox mount -o bind ${SDCARD}/scilab/image ${WWW}/scilab/image
            busybox  chroot  $MNT /bin/bash -c "nohup python /root/rsync.py &>'/dev/null'&"
            sleep 2 
            exit
        fi
        sleep 5
    done   
