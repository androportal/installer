#!/system/bin/sh

export bin=/system/bin
export PATH=$bin:/usr/bin:/usr/sbin:/bin:$PATH
export TERM=linux
export HOME=/root
export MNT=/data/local/linux

export SDCARD=/mnt/sdcard/APL
export WWW=/data/local/linux/var/www/html


busybox umount ${WWW}/c/code
busybox umount ${WWW}/cpp/code
busybox umount ${WWW}/python/code
busybox umount ${WWW}/scilab/code
busybox umount ${WWW}/scilab/image

busybox  chroot  /data/local/linux /bin/bash -c "killall rsync"                                           
busybox  chroot  /data/local/linux /bin/bash -c "killall python"                                           
