#!/bin/bash -x
#
# Author: Jose Ignacio Carretero Guarde
#

CHROOT=chroot.sh

image=${image:-$1}

[ -z $image ] && exit 1

tempdir=$(mktemp -u)
mkdir $tempdir

guestmount -a ${image} -i ${tempdir} || exit 1
mount -o bind /dev ${tempdir}/dev
mount -o bind /proc ${tempdir}/proc
mount -o bind /sys ${tempdir}/sys
mount -o bind /run ${tempdir}/run

issue_file=${tempdir}/etc/issue
if [ -f ${tempdir}/etc/redhat-release ] ; then
   issue_file=${tempdir}/etc/redhat-release
fi


issue=$(head -1 ${issue_file} | awk '{print $1}')
export issue

cat << EOT > ${tempdir}/${CHROOT}
#!/bin/bash

if [ $issue == "Ubuntu" -o $issue == "Debian" ]; then
    apt-get -y purge cloud-init cloud-guest-utils
elif [ $issue == "CentOS" ]; then
    yum -y remove cloud-init
fi

[ -d /home/ubuntu ] && user=ubuntu
[ -d /home/debian ] && user=debian
[ -d /home/centos ] && user=centos

echo "Changing password for \$user"

passwd \$user << INNEREOT
passw0rd
passw0rd
INNEREOT

EOT
chmod +x ${tempdir}/${CHROOT}
chroot ${tempdir} /${CHROOT}
rm ${tempdir}/${CHROOT}

[ -z $nomodeset ] || sed -i 's|console=tty1 console=ttyS0|nomodeset|g' \
                        ${tempdir}/boot/grub/grub.cfg \
                        ${tempdir}/etc/default/grub.d/50-cloudimg-settings.cfg


## Umount the image and remove the tempdir
umount ${tempdir}/dev
umount ${tempdir}/proc
umount ${tempdir}/sys
umount ${tempdir}/run

umount $tempdir
rmdir $tempdir

[ -z $outputformat ] || qemu-img convert -O $outputformat ${image} ${image}.${outputformat}
