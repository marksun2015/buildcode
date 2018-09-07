#!/bin/bash
#rm MTfirmware.bin buildFW
#g++ -o buildFW main.cpp 
projectpath=/home/project/gitxe
targetpath=/home/project/gitcmt3071.eglfs

kernelpath=${projectpath}/kernel
ubootpath=${projectpath}/uboot
rootfspath=${targetpath}/rootfs
oscreatepath=${targetpath}/os_image_create
targetpath=/mnt/wd1/buildimage/_image_cMT3071/
OSNAME_cMT=OS_cMT3071

remove_and_copy ()
{
   	rm ubi.img
	rm uImage
	rm u-boot.img
	rm MLO
	rm MTfirmware.bin

	echo "0" | dialog --gauge "copy uImag ..." 7 60 
	cp ${kernelpath}/arch/arm/boot/uImage .
	usleep 400000 

	echo "25" | dialog --gauge "copy ubi.img ..." 7 60 
	cp ${rootfspath}/ubi.img .
	usleep 300000 
	
	echo "50" | dialog --gauge "copy uboot ..." 7 60 
	cp ${ubootpath}/u-boot.img .
	usleep 300000 
	
	echo "75" | dialog --gauge "copy MLO ..." 7 60 
	cp ${ubootpath}/MLO .
	usleep 300000 
	
	echo "100" | dialog --gauge "copy complete ..." 7 60 
	usleep 300000 
}


build_uboot ()
{
	echo "........... build iE/XE uboot" >>  ${oscreatepath}/log.txt
	cd ${projectpath}
	rm -rf ${projectpath}/uboot
	${projectpath}/ubootclone.sh
	cd ${projectpath}/uboot
	${projectpath}/uboot/build.sh
	cp ${projectpath}/uboot/MLO ${oscreatepath}
	cp ${projectpath}/uboot/u-boot.img ${oscreatepath}
}

build_kernel ()
{
	echo "........... build iE/XE kernel" >>  ${oscreatepath}/log.txt
	cd ${projectpath}
	rm -rf ${projectpath}/kernel
	${projectpath}/kernelclone.sh  
	cd ${projectpath}/kernel/
	${projectpath}/kernel/build.sh e
	cp ${projectpath}/kernel/uImage ${oscreatepath}
	${projectpath}/kernel/build.sh r
	cp ${projectpath}/kernel/recovery.img ${oscreatepath}
}

build_rootfs ()
{
	echo "........... build rootfs" >>  ${oscreatepath}/log.txt
	cd ${rootfspath}
	${rootfspath}/buildrootfs.sh 
}

build_and_copytoFolder ()
{
	echo "........... build_am335x" >>  ${oscreatepath}/log.txt
	cd ${oscreatepath}  
	${oscreatepath}/build_am335x  
	rar a ${targetpath}/$OSNAME_cMT\_$date.rar MLO MTfirmware_AM335x.bin u-boot.img MLO recovery.img 
}

#########################################################
# start
#########################################################
#date=`cat ${rootfspath}/am335x_shrink/etc/version | gawk '{ print $4 }'`

#cancel char "_" in date variable
#date=${date/_/}

build_uboot
build_kernel
build_rootfs
build_and_copytoFolder
#echo "File in $targetpath "
