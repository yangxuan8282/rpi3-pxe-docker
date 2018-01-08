# rpi3-pxe-docker

setup network boot server for raspberry pi 3 use docker

client(enable network boot): 

```
echo program_usb_boot_mode=1 | sudo tee -a /boot/config.txt
```

```
sudo poweroff
```

then prepare system, and start the container

there are two method:

- grab rootfs from `.img` file

for example, prepare raspbian: 

```
sudo apt update && sudo apt install -y git-core
```

```
git clone https://github.com/yangxuan8282/rpi3-pxe-docker ~/work/run/pi-netboot
```

you may need to edit `~/work/run/pi-netboot/dnsmasq.conf` according to your network

```
sudo apt install -y curl bsdtar 
mkdir -p /tmp/raspbian_{boot,root} ~/work/run/pi-netboot/{boot,rootfs} &&
curl -L https://downloads.raspberrypi.org/raspbian_latest | bsdtar -xvf- -C ~/work/run/pi-netboot/
```

```
cd ~/work/run/pi-netboot &&
sudo losetup --partscan --show --find *-raspbian-stretch-lite.img &&
sudo mount /dev/loop0p1 /tmp/raspbian_boot &&
sudo mount /dev/loop0p2 /tmp/raspbian_root &&
cp -a /tmp/raspbian_boot/* ~/work/run/pi-netboot/boot &&
sudo cp -a /tmp/raspbian_root/* ~/work/run/pi-netboot/rootfs
```

```
sudo umount /tmp/raspbian_{boot,root} &&
sudo losetup -d /dev/loop0
```

```
echo "dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=`ip route get 1 | awk '{print $NF;exit}'`:/nfsshare,vers=3 rw ip=dhcp rootwait elevator=deadline" | sudo tee ~/work/run/pi-netboot/boot/cmdline.txt &&
sudo sed -i 's/PARTUUID/#PARTUUID/g' ~/work/run/pi-netboot/rootfs/etc/fstab
```

```
cd ~/work/run/pi-netboot &&
docker-compose up -d
```

> the default latest tags of image is for armhf, for amd64 use `amd64` tags

- copy from running system

```
sudo rsync -xa --progress --exclude /home/pi / ~/work/run/pi-netboot/rootfs
```

```
cp -r /boot/* /tftpboot
```

then edit `cmdline.txt`:

```
echo "dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=`ip route get 1 | awk '{print $NF;exit}'`:/nfsshare,vers=3 rw ip=dhcp rootwait elevator=deadline" | sudo tee ~/work/run/pi-netboot/boot/cmdline.txt &&
sudo sed -i 's/PARTUUID/#PARTUUID/g' ~/work/run/pi-netboot/rootfs/etc/fstab
```

or you can check the official [documentation](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/net_tutorial.md)

the nfs server Dockerfile is from [tangjiujun/docker-nfs-server](https://github.com/tangjiujun/docker-nfs-server)
