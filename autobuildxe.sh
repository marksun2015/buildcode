buildpath=/home/project/buildimage
projectpath=/home/project/gitxe

################################################
rm ${buildpath}/log.txt
echo start build >> ${buildpath}/log.txt
date=`date +'%m-%d %H:%M:%S'`
echo $date >> ${buildpath}/log.txt

#################################################
echo "........... build iE/XE uboot" >>  ${buildpath}/log.txt
cd ${projectpath}
rm -rf ${projectpath}/uboot
${projectpath}/ubootclone.sh
cd ${projectpath}/uboot
${projectpath}/uboot/build.sh

#################################################
echo "........... build iE/XE kernel" >>  ${buildpath}/log.txt
cd ${projectpath}
rm -rf ${projectpath}/kernel
${projectpath}/kernelclone.sh  
cd ${projectpath}/kernel/
${projectpath}/kernel/build.sh l

#################################################3
echo "........... clone rootFS" >>  ${buildpath}/log.txt
cd ${projectpath}
rm -rf ${projectpath}/XE
${projectpath}/rootfsclone.sh

#################################################3
echo "........... build XE release UBIFS" >> ${buildpath}/log.txt
cd ${projectpath}/XE
${projectpath}/XE/build-release-shrink.sh xe 

echo "........... build XE release firmware" >> ${buildpath}/log.txt
cd ${buildpath}
${buildpath}/buildxe.sh

#################################################3
echo "........... build XE debug UBIFS" >> ${buildpath}/log.txt
cd ${projectpath}/XE
${projectpath}/XE/build-debug.sh xe 

echo "........... build XE debug firmware" >> ${buildpath}/log.txt
cd ${buildpath}
${buildpath}/buildxe.sh 

#################################################3
echo end build >> ${buildpath}/log.txt
date=`date +'%m-%d %H:%M:%S'`
echo $date >> ${buildpath}/log.txt

echo "!!!!!!!Remember add u-boot NAND delay!!!!!!!"
#################################################3

