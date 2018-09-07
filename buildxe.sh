#!/bin/bash
#rm MTfirmware.bin buildFW
#g++ -o buildFW main.cpp 
projectpath=/home/project/gitxe
targetpath=/mnt/wd1/buildimage/_image_XE/

kernelpath=${projectpath}/kernel
ubootpath=${projectpath}/uboot
rootfspath=${projectpath}/XE
versionpath=${rootfspath}/am335x_shrink/etc/version 

sdb2path=/mnt/win7_2/_image_XE
OSNAME=OS_MT8000XE

check_path ()
{
    if [[ ! -e ${kernelpath}/arch/arm/boot/uImage ]]; then
	echo "kernel(uImage) not exist!!!!"
    	exit 0
    fi
    if [[ ! -e ${rootfspath}/ubi.img ]]; then
	echo "rootFS(ubi.img) not exist!!!!"
	exit 0
    fi
    if [[ ! -e ${rootfspath}/OS_checksum.bin ]]; then
	echo "checksum(OS_checksum.bin) not exist!!!!"
	exit 0
    fi
    if [[ ! -e ${ubootpath}/u-boot.img ]]; then
	echo "u-boot.img not exist!!!!"
    	exit 0
    fi
    if [[ ! -e ${ubootpath}/MLO ]]; then
	echo "MLO not exist!!!!"
	exit 0
    fi
}

check_iEXE ()
{   
    version=`cat ${versionpath} | gawk '{ print $1 }'`
	echo "--------$version--------"
    if [ $version != "MT8xxx(XE)" ];then
    	echo "not match XE, maybe a iE rootFS"
	exit 0
    else
	echo "--------build XE version--------"
    fi
}

remove_and_copy ()
{
   	rm ubi.img
   	rm OS_checksum.bin
	rm uImage
	rm u-boot.img
	rm MLO
	rm MTfirmware.bin
	cp ${kernelpath}/arch/arm/boot/uImage .
	cp ${rootfspath}/ubi.img .
	cp ${rootfspath}/OS_checksum.bin .
	cp ${ubootpath}/u-boot.img .
	cp ${ubootpath}/MLO .
}

build_and_copytoFolder ()
{
	./buildFW_config config_files/XE-typeB.conf
	\cp MTfirmware.bin u-boot.img MLO OS_checksum.bin ${targetpath}	
	rm ubi.img
   	rm OS_checksum.bin
	rm uImage
	rm u-boot.img
	rm MLO
	#rm MTfirmware.bin
	cd ${targetpath}
	rar a $OSNAME\_$date.rar MLO MTfirmware.bin u-boot.img OS_checksum.bin
	echo "File in $targetpath"
}

##################################################################
# start
##################################################################

date=`cat ${rootfspath}/am335x_shrink/etc/version | gawk '{ print $4 }'`

#cancel char "_" in date variable
date=${date/_/}

check_path
check_iEXE
remove_and_copy
build_and_copytoFolder
