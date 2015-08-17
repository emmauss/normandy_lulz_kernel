#!/system/bin/sh
# Copyright (c) 2009-2012, The Linux Foundation. All rights reserved.
#

export PATH=/sbin:/system/sbin:/system/bin:/system/xbin
mount -o rw,remount /

echo 512 > /sys/block/mmcblk0/queue/read_ahead_kb
echo 1024 > /sys/block/mmcblk1/queue/read_ahead_kb

chown system /sys/devices/platform/rs300000a7.65536/force_sync
chown system /sys/devices/platform/rs300000a7.65536/sync_sts
chown system /sys/devices/platform/rs300100a7.65536/force_sync
chown system /sys/devices/platform/rs300100a7.65536/sync_sts

echo 5 > /sys/devices/platform/msm_sdcc.1/idle_timeout

# Enable Power modes and set the CPU Freq Sampling rates
start qosmgrd
echo 1 > /sys/module/pm2/modes/cpu0/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/pm2/modes/cpu1/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/pm2/modes/cpu0/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/pm2/modes/cpu1/standalone_power_collapse/suspend_enabled
# SuspendPC:
echo 1 > /sys/module/pm2/modes/cpu0/power_collapse/suspend_enabled
# IdlePC:
echo 1 > /sys/module/pm2/modes/cpu0/power_collapse/idle_enabled

# Start thermal daemon.
start thermald

# Touchscreen
echo 1 > /sys/android_touch/setvol

# Change adj level and min_free_kbytes setting for lowmemory killer to kick in.
echo "0,117,176,294,411,529" >> /sys/module/lowmemorykiller/parameters/adj
echo "4096,8192,16384,32768,49152,65536" >> /sys/module/lowmemorykiller/parameters/minfree

# Network tweaks.
sysctl -e -w net.ipv4.tcp_timestamps=0
sysctl -e -w net.ipv4.tcp_tw_reuse=1
sysctl -e -w net.ipv4.tcp_tw_recycle=1
sysctl -e -w net.ipv4.tcp_sack=1
sysctl -e -w net.ipv4.tcp_window_scaling=1
sysctl -e -w net.ipv4.tcp_keepalive_probes=5
sysctl -e -w net.ipv4.tcp_ecn=0
sysctl -e -w net.ipv4.tcp_max_tw_buckets=360000
sysctl -e -w net.ipv4.tcp_synack_retries=2
sysctl -e -w net.ipv4.route.flush=1
sysctl -e -w net.ipv4.icmp_echo_ignore_all=1
sysctl -e -w net.ipv4.conf.all.rp_filter=1
sysctl -e -w net.ipv4.tcp_synack_retries=2
sysctl -e -w net.ipv4.tcp_syn_retries=2
sysctl -e -w net.ipv4.tcp_no_metrics_save=1
sysctl -e -w net.ipv4.tcp_fin_timeout=15
sysctl -e -w net.ipv4.tcp_keepalive_intvl=60
sysctl -e -w net.ipv4.tcp_keepalive_time=1800
sysctl -e -w net.ipv4.tcp_ecn=1
sysctl -e -w net.ipv4.conf.all.secure_redirects=0
sysctl -e -w net.ipv4.conf.default.secure_redirects=0
sysctl -e -w net.core.bpf_jit_enable=1
sysctl -e -w net.core.wmem_max=25600
sysctl -e -w net.core.rmem_max=25600
sysctl -e -w net.core.rmem_default=25600
sysctl -e -w net.core.wmem_default=25600

# Various kernel memory settings.
sysctl -e -w fs.nr_open=1053696
sysctl -e -w fs.inotify.max_queued_events=32000
sysctl -e -w fs.inotify.max_user_instances=256
sysctl -e -w fs.inotify.max_user_watches=10240
sysctl -e -w kernel.msgmni=2048
sysctl -e -w kernel.msgmax=64000
sysctl -e -w kernel.shmmni=4096
sysctl -e -w kernel.shmall=2097152
sysctl -e -w kernel.shmmax=268435456
sysctl -e -w kernel.sched_latency_ns=18000000
sysctl -e -w kernel.sched_min_granularity_ns=1500000
sysctl -e -w kernel.sched_wakeup_granularity_ns=3000000
sysctl -e -w kernel.sched_shares_ratelimit=256000
sysctl -e -w kernel.threads-max=10000
sysctl -e -w fs.file-max=65536
sysctl -e -w fs.lease-break-time=10
sysctl -e -w vm.dirty_ratio=60
sysctl -e -w vm.dirty_background_ratio=40
sysctl -e -w vm.vfs_cache_pressure=20
sysctl -e -w vm.oom_kill_allocating_task=0
sysctl -e -w vm.dirty_expire_centisecs=2000
sysctl -e -w vm.dirty_writeback_centisecs=1000
sysctl -e -w vm.panic_on_oom=0
sysctl -e -w vm.overcommit_memory=1
sysctl -e -w vm.overcommit_ratio=40
sysctl -e -w vm.swappiness=70
sysctl -e -w vm.min_free_kbytes=4096
sysctl -e -w kernel.panic_on_oops=0
sysctl -e -w kernel.panic=0
sysctl -e -w kernel.sched_compat_yield=1
sysctl -e -w kernel.sched_child_runs_first=0

# Memory tweaks.
setprop ro.FOREGROUND_APP_ADJ 0
setprop ro.VISIBLE_APP_ADJ 3
setprop ro.PERCEPTIBLE_APP_ADJ 2
setprop ro.HEAVY_WEIGHT_APP_ADJ 4
setprop ro.SECONDARY_SERVER_ADJ 5
setprop ro.BACKUP_APP_ADJ 6
setprop ro.HOME_APP_ADJ 2
setprop ro.HIDDEN_APP_MIN_ADJ 7
setprop ro.EMPTY_APP_ADJ 15
setprop ro.FOREGROUND_APP_MEM 1536
setprop ro.VISIBLE_APP_MEM 2048
setprop ro.PERCEPTIBLE_APP_MEM 1024
setprop ro.HEAVY_WEIGHT_APP_MEM 6400
setprop ro.SECONDARY_SERVER_MEM 6400
setprop ro.BACKUP_APP_MEM 7680
setprop ro.HOME_APP_MEM 1024
setprop ro.HIDDEN_APP_MEM 7680
setprop ro.EMPTY_APP_MEM 8960

if [ -d /system/priv-app ]
	then
		mkdir -p /storage/sdcard0/sdbind
		mkdir -p /mnt/media_rw/sdcard0/sdbind
		mkdir -p /mnt/media_rw/sdcard1
		mount -o bind /mnt/media_rw/sdcard0/sdbind /mnt/media_rw/sdcard1
		mount -o bind /storage/sdcard0/sdbind /storage/sdcard1
	else
		# Activate zram.
		echo "$((70 * 1024 * 1024))" >> /sys/block/zram0/disksize
		mkswap /dev/block/zram0
		swapon /dev/block/zram0
fi

echo "I: POST script finished" >> /dboot.log
echo "#### DualBoot V4 ####" >> /dboot.log
echo "### xda@lukino563 ###" >> /dboot.log

