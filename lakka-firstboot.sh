#!/bin/sh
#fix lakka network issues, from: https://github.com/libretro/Lakka-LibreELEC/issues/492#issuecomment-399735924

for folders in cores database assets joypads shaders; do
	mkdir -p /storage/.config/retroarch/$folders
done

ln -sf /usr/lib/libretro/* /storage/.config/retroarch/cores/
ln -sf /usr/share/libretro-database/* /storage/.config/retroarch/database/
ln -sf /usr/share/retroarch-assets/* /storage/.config/retroarch/assets/
ln -sf /etc/retroarch-joypad-autoconfig/* /storage/.config/retroarch/joypads/
ln -sf /usr/share/common-shaders/* /storage/.config/retroarch/shaders/

sleep 3

sed -e "s|/tmp/|/storage/.config/retroarch/|g" -i /storage/.config/retroarch/retroarch.cfg

