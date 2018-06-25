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

```
./setup.sh
```

or you can check the official [documentation](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/net_tutorial.md)

for LibreELEC, install it to sdcard first, then copy the content in first partition to `os/boot`
edit and copy the libreelec-cmdline.txt to `os/boot/cmdline.txt`

for Lakka, need some tweaks from this [comment](https://github.com/libretro/Lakka-LibreELEC/issues/492#issuecomment-399735924)

for gaming use, you may consider installing LibreELEC + this [addons](https://github.com/bite-your-idols/Gamestarter)

the nfs server Dockerfile is from [tangjiujun/docker-nfs-server](https://github.com/tangjiujun/docker-nfs-server)
