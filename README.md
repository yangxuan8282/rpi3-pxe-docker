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

for Lakka, it not work out of box:

use the `setup-libreelec.sh`, just replace the url

after boot run `lakka-firstboot.sh` once from ssh

reboot manually, it should works now


the nfs server Dockerfile is from [tangjiujun/docker-nfs-server](https://github.com/tangjiujun/docker-nfs-server)
