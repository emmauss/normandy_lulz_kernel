#!/sbin/busybox sh

#################################
## DUALBOOT SCRIPT FOR NOKIA X ##
########### VERSION 4 ###########
set +x
bootPATH="$PATH"
export PATH=/sbin
export bb=busybox

cd /
exec >>dboot.log 2>&1
$bb rm /init

#############
## PREPARE ##
#############
$bb mount -o remount,rw rootfs /
$bb mkdir -p /sys /tmp /proc /data /dev /system/bin /cache
$bb mount -t sysfs sysfs /sys
$bb mount -t proc proc /proc
$bb mount -t debugfs debugfs /sys/kernel/debug
$bb mkdir /dev/input /dev/graphics /dev/block /dev/log

echo "I: Processor type: `$bb grep Processor /proc/cpuinfo | $bb sed 's/.*: //'`"
echo "I: Installed kernel: `$bb uname -r`"
echo "I: Busybox version: `$bb | { IFS= read -r first; echo "$first"; } | $bb awk '{print $2;}'`"

$bb mknod -m 666 /dev/null c 1 3
$bb mknod -m 666 /dev/graphics/fb0 c 29 0
$bb mknod -m 666 /dev/tty0 c 4 0
$bb mknod -m 600 /dev/block/mmcblk0 b 179 0
$bb mknod -m 600 /dev/block/mmcblk0p19 b 179 19
$bb mknod -m 666 /dev/log/system c 10 19
$bb mknod -m 666 /dev/log/radio c 10 20
$bb mknod -m 666 /dev/log/events c 10 21
$bb mknod -m 666 /dev/log/main c 10 22
$bb mknod -m 666 /dev/ashmem c 10 37
$bb mknod -m 666 /dev/urandom c 1 9

############
## CONFIG ##
############
$bb mount /dev/block/mmcblk0p19 /cache

if [ ! -f /cache/dualboot.cfg ]
	then
		echo "W: Config not found."
		$bb touch /cache/dualboot.cfg
		#echo "# Obsolete file used for compatibility" > /cache/dualboot.cfg
		echo "external_type=kk" >> /cache/dualboot.cfg
		. /cache/dualboot.cfg
		echo "I: Config created & loaded with default settings"
	else
		. /cache/dualboot.cfg
		echo "I: Config found & loaded"
fi

##############
## DUALBOOT ##
##############
if [ ${external_type} == "lp" ]
	then
		$bb rm /*.rc /*.sh /*.prop
		echo "I: External ROM: Lollipop"
fi
$bb mknod -m 600 /dev/input/event5 c 13 69
echo 170 > /sys/class/timed_output/vibrator/enable
$bb cat /dev/input/event5 > /dev/keycheck&
echo $! > /dev/keycheck.pid
$bb sleep 5.170
echo 170 > /sys/class/timed_output/vibrator/enable
$bb kill -9 $($bb cat /dev/keycheck.pid)
if [ -s /dev/keycheck ]
	then
		$bb cpio -i < /sbin/${external_type}.cpio &> /dev/null
		$bb cp /sbin/${external_type}.fstab /fstab.qcom
		echo "I: Booting external rom"
	else
		$bb cpio -i < /sbin/jb.cpio &> /dev/null
		$bb cp /sbin/jb.fstab /fstab.qcom
		echo "I: Booting internal rom"
fi

#########################
## PERFORMANCE TUNNING ##
#########################
echo 0 > /sys/module/intelli_plug/parameters/intelli_plug_active
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1008000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 122880 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1008000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
echo 122880 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo 1 > /sys/module/intelli_plug/parameters/intelli_plug_active
echo 350000000 > /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/gpuclk
echo 350000000 > /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/max_gpuclk
echo 1024 > /proc/sys/kernel/random/read_wakeup_threshold
echo 2048 > /proc/sys/kernel/random/write_wakeup_threshold
echo 1 > /sys/kernel/debug/tracing/cpu_freq_switch_profile_enabled
echo 0 > /sys/kernel/logger_mode/logger_mode

###############
## POST CMDS ##
###############
$bb umount /cache
$bb umount /sys/kernel/debug
$bb umount /proc
$bb umount /sys

$bb rm -fr /dev/*
for k in kk.* jb.* lp.* init.sh busybox
do
	$bb rm -r /sbin/$k
done

unset bb
export PATH="${bootPATH}"
exec /init

#################################

