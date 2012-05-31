#!/system/bin/sh

export bin=/system/bin
export PATH=$bin:/usr/bin:/usr/sbin:/bin:$PATH
export TERM=linux
export HOME=/root
export MNT=/data/local/linux

if [ ! -d $MNT ]
then
mkdir -p $MNT
fi


busybox chroot $MNT /bin/bash -c "mkdir /proc"
busybox chroot $MNT /bin/bash -c "mkdir /sys"
busybox chroot $MNT /bin/bash -c "mkdir -p /dev/pts"

busybox mount -t devpts devpts $MNT/dev/pts
busybox mount -t proc proc $MNT/proc
busybox mount -t sysfs sysfs $MNT/sys


# entering the chroot environment - for debugging (uncomment line below)
#busybox chroot $MNT /bin/bash

# setting proxy (!!!! for internal use only !!!!)
#busybox chroot $MNT /bin/bash -c "source /root/.bashrc"

# starting apache and setting up frame-buffer externally using chroot (uncomment line below)
#busybox chroot $MNT /bin/bash -c "rm /var/run/apache2.pid"
#busybox chroot $MNT /bin/bash -c "apache2ctl graceful"

busybox chroot $MNT /bin/bash -c "rm /dev/null"
busybox  chroot  $MNT /bin/sh -c "rm /var/run/apache2/*"
busybox  chroot  $MNT /bin/sh -c "service apache2 stop"
busybox  chroot  $MNT /bin/sh -c "service apache2 start"
busybox chroot $MNT /bin/bash -c "rm /tmp/.X1-*" 
#busybox chroot $MNT /bin/bash -c "kill -9 $(pgrep Xvfb)" 
busybox chroot $MNT /bin/bash -c "nohup Xvfb :1 -screen 0 640x480x24 -ac < /dev/null > Xvfb.out 2> Xvfb.err &"

#busybox umount $MNT/proc 
#busybox umount $MNT/sys
