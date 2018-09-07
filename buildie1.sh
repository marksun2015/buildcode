#!/bin/bash
#rm MTfirmware.bin buildFW
#g++ -o buildFW main.cpp 
projectpath=/home/project/gitam335x
targetpath=/mnt/wd1/buildimage/_image_iE_typeA/

kernelpath=${projectpath}/kernel
ubootpath=${projectpath}/uboot
rootfspath=${projectpath}/iE
versionpath=${rootfspath}/am335x_shrink/etc/version 
OSNAME=OS_MT8000iE_TypeA

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
    if [[ ! -e ${ubootpath}/u-boot.img ]]; then
	echo "u-boot.img not exist!!!!"
	exit 0
    fi
    if [[ ! -e ${ubootpath}/MLO ]]; then
	echo "MLO not exist!!!!"
	exit 0
    fi
}
remove_and_copy ()
{
   	rm ubi.img
	rm uImage
	rm u-boot.img
	rm MLO
	rm MTfirmware.bin

	echo "0" | dialog --gauge "copy ubi.img ..." 7 60 
	cp ${rootfspath}/ubi.img .
	usleep 100000 
	
	echo "25" | dialog --gauge "copy uImage ..." 7 60 
	cp ${kernelpath}/arch/arm/boot/uImage .
	usleep 100000
	
	echo "50" | dialog --gauge "copy u-boot.img ..." 7 60 
	cp ${ubootpath}/u-boot.img .
	usleep 100000
	
	echo "75" | dialog --gauge "copy MLO..." 7 60 
	cp ${ubootpath}/MLO .
	usleep 100000
	
	echo "100" | dialog --gauge "copy complete" 7 60 
	usleep 200000

}

build_and_copytoFolder ()
{
	./buildFW 1
	\cp MTfirmware.bin u-boot.img MLO ${targetpath}
	rar a $OSNAME\_$date.rar MLO MTfirmware.bin u-boot.img
	rm ubi.img
	rm uImage
	rm u-boot.img
	rm MLO
	rm MTfirmware.bin
	cp $OSNAME\_$date.rar ${targetpath}
	rm $OSNAME*
	echo "copy file to $targetpath"
}

##########################################################
# start
##########################################################
date=`cat ${versionpath} | gawk '{ print $4 }'`

#cancel char "_" in date variable
date=${date/_/}

check_path
remove_and_copy
build_and_copytoFolder

