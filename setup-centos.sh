#!/bin/sh

set -xe

die() {
	printf '\033[1;31mERROR:\033[0m %s\n' "$@" >&2  # bold red
	exit 1
}

which unxz > /dev/null || die 'please install xz'
which docker > /dev/null || die 'please install docker'
which docker-compose > /dev/null || die 'please install docker-compose with: sudo pip3 install docker-compose'
which losetup > /dev/null || die 'please install losetup'

cd "$(dirname "$0")"

DEST=$(pwd)

url="https://mirrors.tuna.tsinghua.edu.cn/centos-altarch/7.5.1804/isos/armhfp"
file_name="CentOS-Userland-7-armv7hl-RaspberryPI-Minimal-1804-sda.raw"
server_ip=$(ip route get 1 | awk '{print $NF;exit}')

mkdir -p os/boot os/root

wget $url/"$file_name".xz

unxz "$file_name".xz

loop_dev=$(sudo losetup --find --show -P "$file_name")

mkdir -p /tmp/cent_boot /tmp/cent_root

sudo mount "$loop_dev"p1 /tmp/cent_boot
sudo mount "$loop_dev"p3 /tmp/cent_root

cp -a /tmp/cent_boot/* os/boot/
sudo cp -a /tmp/cent_root/* os/root/

sudo umount /tmp/cent_boot /tmp/cent_root
sudo losetup -d "$loop_dev"
rm -f "$file_name"

echo "console=ttyAMA0,115200 console=tty1 selinux=0 root=/dev/nfs \
	nfsroot=$server_ip:/nfsshare/root,vers=3 rw ip=dhcp elevator=deadline rootwait" | tee os/boot/cmdline.txt

sudo rm -f os/root/etc/fstab && sudo touch os/root/etc/fstab

sudo cp /etc/resolv.conf os/root/etc/resolv.conf

echo "raspberrypi" | sudo tee os/root/etc/hostname

echo "127.0.0.1		raspberrypi.localdomain localhost" | sudo tee os/root/etc/hosts

docker-compose up -d
