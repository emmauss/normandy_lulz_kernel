export toolchains=`ls ~/toolchains`
export re='^[0-9]+$'
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ $2 != "flash" ] && [ $2 != "noflash" ] || ! [[ $3 =~ $re ]]
	then
		echo ""
		echo "Use: build.sh [toolchain] [flash/noflash] [version]"
		echo ""
		echo "Options:"
		echo "Available toolchains:   `echo $toolchains`"
		echo "Flash:                  flash   -- this will flash kernel and install modules when compilation is finished"
		echo "                        noflash -- this will stop after compilation"
		echo "Version:                #number -- number from 0 to #"
		echo ""
		echo "Created by lukino563"
		echo "more info in forum.xda-developers.com in Nokia X section"
		echo ""
		exit 0
		
fi
PATH=/home/ubuntu/toolchains/$1/bin:$PATH
export PATH
export CROSS_COMPILE="/home/ubuntu/toolchains/$1/bin/arm-eabi-"
export COMPILE_VERSION=$3
make menuconfig
cp .config arch/arm/configs/normandy_prep_defconfig
make clean
make mrproper
make normandy_prep_defconfig
make -j4
cp arch/arm/boot/zImage scripts/compilekit/split_img/boot.img-zImage
mkdir -p compiled
cd scripts/compilekit
./repackimg.sh > /dev/null
cd ../..
cp scripts/compilekit/image-new.img compiled/boot.img
if [[ $2 == "flash" ]]
	then
		adb root
		sleep 5
		adb shell mount -o rw,remount /
		adb remount
		adb push net/wireless/cfg80211.ko /system/lib/modules
		adb push drivers/net/wireless/libra/librasdioif.ko /system/lib/modules
		adb shell chmod 644 /system/lib/modules/*.ko
		adb push compiled/boot.img /im
		adb shell dd if=/im of=/dev/block/mmcblk0p17
		adb reboot
fi
