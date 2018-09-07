buildpath=/home/project/buildimage
projectpath=/home/project/gitam335x

################################################
rm ${buildpath}/log.txt
echo start build >> ${buildpath}/log.txt
date=`date +'%m-%d %H:%M:%S'`
echo $date >> ${buildpath}/log.txt

#################################################3
echo "........... build iE typeA uboot" 
cd ${projectpath}
rm -rf ${projectpath}/uboot
${projectpath}/ubootclone.sh
cd ${projectpath}/uboot
${projectpath}/uboot/build.sh

#################################################3
echo "........... build iE typeA kernel"
cd ${projectpath}
rm -rf ${projectpath}/kernel
${projectpath}/kernelclone.sh  
cd ${projectpath}/kernel
${projectpath}/kernel/build.sh

#################################################3
cd ${projectpath}
rm -rf ${projectpath}/iE
${projectpath}/rootfsclone.sh

#################################################3
echo "........... build iE typeA release UBIFS"
cd ${projectpath}/iE
${projectpath}/iE/build-release-shrink.sh

echo "........... build iE type A release firmware"
cd ${buildpath}
${buildpath}/buildie1.sh 

#################################################3
echo "........... build iE type A debug UBIFS"
cd ${projectpath}/iE
${projectpath}/iE/build-debug.sh 

echo "........... build iE type A debug firmware"
cd ${buildpath}
${buildpath}/buildie1.sh 

#################################################
echo end build >> ${buildpath}/log.txt
date=`date +'%m-%d %H:%M:%S'`
echo $date >> ${buildpath}/log.txt

echo "!!!!!!!Remember add u-boot NAND delay!!!!!!!"
#################################################
