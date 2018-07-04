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

edit `dnsmasq.conf` according to your network

for Raspbian Lite:

```
./setup.sh
```

or you can check the official [documentation](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/net_tutorial.md)

for LibreELEC:

```
./setup-libreelec.sh
```

for Lakka:

```
./setup-lakka.sh
```

fot other os, most system should work with netboot, tested: DietPi, piCore(tinycorelinux), pilfs(although not a distros), Sabayon, voidlinux, Devuan, AOSC, openSUSE(armhf, aarch64), if not work use the raspbian [boot tarball](http://downloads.raspberrypi.org/raspbian_lite/archive/2018-06-29-03:25/boot.tar.xz) instead, for alpine need comment out alpine initramfs in config.txt(the new alpine rpi kernel seems have some issues, need use raspbian kernel)

not work: archlinux arm, manjaro arm, fedora(kernel panic), ubuntu rpi2 image(stuck at network config)

the nfs server Dockerfile is from [tangjiujun/docker-nfs-server](https://github.com/tangjiujun/docker-nfs-server)
