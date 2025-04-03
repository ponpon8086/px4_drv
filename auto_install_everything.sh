#!/bin/bash

#check secure boot status
sudo apt-get update && sudo apt-get install -y mokutil
secure_status=`mokutil --sb-state`

if [[ $secure_status == "SecureBoot enabled" ]]; then
        echo -e "\n\nsecure boot is enable. Please disable it by BIOS menu!!!\n\n"
        exit
fi

#prep
sudo apt-get install -y debhelper devscripts dh-exec dkms dpkg wget

#prep for tuner fw dump
cd fwtool
make
cd ../

mkdir -p _build/dump
cp fwtool/fwtool _build/dump
cp fwtool/fwinfo.tsv _build/dump
cd _build/dump

if [[ $1 == "PX-Q3U4" ]]; then
        wget https://plex-net.co.jp/download/202104_PX-Q3U4_Driver.zip
        unzip -oj 202104_PX-Q3U4_Driver.zip 202104_PX-Q3U4_Driver/x64/PXQ3U4.sys && rm 202104_PX-Q3U4_Driver.zip
        ./fwtool PXQ3U4.sys it930x-firmware.bin && rm PXQ3U4.sys
        cp it930x-firmware.bin ../../etc/
fi

if [[ $1 == "PX-W3U4" ]]; then
        wget https://plex-net.co.jp/download/202104_PX-W3U4_Driver.zip
        unzip -oj 202104_PX-W3U4_Driver.zip 202104_PX-W3U4_Driver/x64/PXW3U4.sys && rm 202104_PX-W3U4_Driver.zip
        ./fwtool PXW3U4.sys it930x-firmware.bin && rm PXW3U4.sys
        cp it930x-firmware.bin ../../etc/
fi

if [[ $1 == "PX-Q3PE5" ]]; then
        wget https://plex-net.co.jp/download/202201_PX-Q3PE5_Driver.zip
        unzip -oj 202201_PX-Q3PE5_Driver.zip 202201_PX-Q3PE5_Driver/x64/PXQ3PE5.sys && rm 202201_PX-Q3PE5_Driver.zip
        ./fwtool PXQ3PE5.sys it930x-firmware.bin && rm PXQ3PE5.sys
        cp it930x-firmware.bin ../../etc/
fi

if [[ $1 == "PX-W3PE5" ]]; then
        wget https://plex-net.co.jp/download/202104_PX-W3PE5_Driver.zip
        unzip -oj 202104_PX-W3PE5_Driver.zip 202104_PX-W3PE5_Driver/x64/PXW3PE5.sys && rm 202104_PX-W3PE5_Driver.zip
        ./fwtool PXW3PE5.sys it930x-firmware.bin && rm PXW3PE5.sys
        cp it930x-firmware.bin ../../etc/
fi

if [[ $1 == "PX-MLT8PE3" ]]; then
        wget https://plex-net.co.jp/download/202104_PX-MLT8PE_Driver.zip
        unzip -oj 202104_PX-MLT8PE_Driver.zip 202104_PX-MLT8PE_Driver/x64/PXMLT8PE3.sys && rm 202104_PX-MLT8PE_Driver.zip
        ./fwtool PXMLT8PE3.sys it930x-firmware.bin && rm PXMLT8PE3.sys
        cp it930x-firmware.bin ../../etc/
fi

if [[ $1 == "PX-MLT8PE5" ]]; then
        wget https://plex-net.co.jp/download/202104_PX-MLT8PE_Driver.zip
        unzip -oj 202104_PX-MLT8PE_Driver.zip 202104_PX-MLT8PE_Driver/x64/PXMLT8PE5.sys && rm 202104_PX-MLT8PE_Driver.zip
        ./fwtool PXMLT8PE5.sys it930x-firmware.bin && rm PXMLT8PE5.sys
        cp it930x-firmware.bin ../../etc/
fi

if [[ $1 == "PX-MLT5PE" ]]; then
        wget https://plex-net.co.jp/download/202104_PX-MLT5PE_Driver.zip
        unzip -oj 202104_PX-MLT5PE_Driver.zip 202104_PX-MLT5PE_Driver/x64/PXMLT5PE.sys && rm 202104_PX-MLT5PE_Driver.zip
        ./fwtool PXMLT5PE.sys it930x-firmware.bin && rm PXMLT5PE.sys
        cp it930x-firmware.bin ../../etc/
fi

if [[ $1 == "PX-Q3PE4" ]] || [[ $1 == "PX-W3PE4" ]]; then
        wget http://plex-net.co.jp/download/pxq3pe4v1.4.zip
        unzip -oj pxq3pe4v1.4.zip pxq3pe4v1/x64/PXQ3PE4.sys && rm pxq3pe4v1.4.zip
        ./fwtool PXQ3PE4.sys it930x-firmware.bin && rm PXQ3PE4.sys
        cp it930x-firmware.bin ../../etc/
fi

cd ../../
rm -rf _build

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
