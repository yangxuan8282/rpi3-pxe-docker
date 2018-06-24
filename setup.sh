#!/bin/sh

set -xe

die() {
	printf '\033[1;31mERROR:\033[0m %s\n' "$@" >&2  # bold red
	exit 1
}

which xz > /dev/null || die 'please install xz'
which docker > /dev/null || die 'please install docker'
which docker-compose > /dev/null || die 'please install docker-compose with: sudo pip3 install docker-compose'

cd "$(dirname "$0")"

DEST=$(pwd)

url="http://downloads.raspberrypi.org/raspbian_lite/archive/2018-04-19-15:24"
server_ip=$(ip route get 1 | awk '{print $NF;exit}')

mkdir -p os/boot os/root

wget $url/boot.tar.xz -O- | tar -C os/boot -xJf -
wget $url/root.tar.xz -O- | sudo tar -C os/root -xJf -

echo "dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=/dev/nfs \
	nfsroot=$server_ip:/nfsshare/root,vers=3 rw ip=dhcp rootwait elevator=deadline" | \
	sudo tee os/boot/cmdline.txt

echo "proc                           /proc           proc    defaults          0       0
"$server_ip":/nfsshare/boot   /boot           nfs     defaults          0       0" | sudo tee os/root/etc/fstab

sudo rm -f os/root/etc/init.d/resize2fs_once

docker-compose up -d
