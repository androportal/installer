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

busybox mount -t devpts devpts $MNT/dev/pts
busybox mount -t proc proc $MNT/proc
busybox mount -t sysfs sysfs $MNT/sys 

# setting proxy (!!!! for internal use only !!!!)
busybox chroot $MNT /bin/bash -c "source /root/.bashrc"

# entering the chroot environment - for debugging (uncomment line below)
busybox chroot $MNT /bin/bash
