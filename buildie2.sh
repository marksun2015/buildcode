#!/bin/bash
#rm MTfirmware.bin buildFW
#g++ -o buildFW main.cpp 
projectpath=/home/project/gitxe
targetpath=/mnt/wd1/buildimage/_image_iE_typeB/

kernelpath=${projectpath}/kernel
ubootpath=${projectpath}/uboot
rootfspath=${projectpath}/XE
versionpath=${rootfspath}/am335x_shrink/etc/version 
OSNAME_iP=OS_MT8000iE_iP
OSNAME_iE=OS_MT8000iE_TypeB

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
	version=`cat /home/gitxe/XE/am335x_shrink/etc/version | gawk '{ print $1 }'`
	if [ $version != "MT8xxx(iE)" ];then
	    echo "not match iE, maybe a XE rootFS"
	    exit 0
	else
	    echo "---------build iE version---------"
	fi
}

remove_and_copy ()
{
    rm ubi.img
	rm OS_checksum.bin
	rm uImage
	rm u-boot.img
	rm MLO
	#rm MTfirmware.bin

	echo "0" | dialog --gauge "copy uImag ..." 7 60 
	cp ${kernelpath}/arch/arm/boot/uImage .
	usleep 400000 

	echo "25" | dialog --gauge "copy ubi.img ..." 7 60 
	cp ${rootfspath}/ubi.img .
	usleep 300000 
	
	echo "35" | dialog --gauge "copy OS_checksum.bin ..." 7 60 
	cp ${rootfspath}/OS_checksum.bin .
	usleep 300000 
	
	echo "55" | dialog --gauge "copy uboot ..." 7 60 
	cp ${ubootpath}/u-boot.img .
	usleep 300000 
	
	echo "75" | dialog --gauge "copy MLO ..." 7 60 
	cp ${ubootpath}/MLO .
	usleep 300000 
	
	echo "100" | dialog --gauge "copy complete ..." 7 60 
	usleep 300000 
}

build_and_copytoFolder ()
{
	./buildFW_config config_files/iE-typeB.conf
	\cp MTfirmware.bin u-boot.img MLO OS_checksum.bin ${targetpath}	
	rm ubi.img
	rm OS_checksum.bin
	rm uImage
	#rm u-boot.img
	#rm MLO
	#rm MTfirmware.bin
	currentpath=`pwd`
	rm $currentpath/*.rar

	cd ${targetpath}

	rar a $OSNAME_iE\_$date.rar MLO MTfirmware.bin u-boot.img OS_checksum.bin
	rar a $OSNAME_iP\_$date.rar MLO MTfirmware.bin u-boot.img
	cp $OSNAME_iE\_$date.rar $currentpath
	cp $OSNAME_iP\_$date.rar $currentpath
	echo "File in $targetpath "
}

#########################################################
# start
#########################################################
date=`cat ${rootfspath}/am335x_shrink/etc/version | gawk '{ print $4 }'`

#cancel char "_" in date variable
date=${date/_/}

check_path
check_iEXE
remove_and_copy
build_and_copytoFolder
echo "File in $targetpath "
echo "--------------!! Watch out !!-------------------"
echo "1. iE/XE need checksum !!!!!!!!"
echo "2. Crouset must match latest HW version"
