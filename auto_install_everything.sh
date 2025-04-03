#!/bin/bash

#check secure boot status
sudo apt-get update && sudo apt-get install -y mokutil
secure_status=`mokutil --sb-state`

if [[ $secure_status == "SecureBoot enabled" ]]; then
        echo -e "\n\nsecure boot is enable. Please disable it by BIOS menu!!!\n\n"
        exit
fi

#prep
sudo apt-get install -y debhelper devscripts dh-exec dkms dpkg

#prep for tuner fw dump
cd fwtool
make
cd ../

#driver install by DKMS
sudo cp -a ./ /usr/src/px4_drv-0.5.2
sudo dkms add px4_drv/0.5.2
sudo dkms install px4_drv/0.5.2

#build recpt1 for tuner verify
sudo apt-get install -y automake autoconf
rm -rf _build
mkdir _build
cd _build
git clone https://github.com/stz2012/recpt1.git
cd recpt1/recpt1
./autogen.sh
./configure
make
cp checksignal ../../../verify/
cp recpt1 ../../../verify/
cp recpt1ctl ../../../verify/
cd ../../../
rm -rf _build
