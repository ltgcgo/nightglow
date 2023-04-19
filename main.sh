#!/bin/bash
use ./wgcf.sh
use ./singbox.sh
echo "Updating helper script..."
mkdir -p $PREFIX/opt/nightglow
cd $PREFIX/opt/nightglow
curl -Lo nightglow.sh https://github.com/ltgcgo/nightglow/raw/main/nightglow.sh
chmod +x nightglow.sh
ln -s $PREFIX/opt/nightglow/nightglow.sh $PREFIX/bin/nightglow
useradd nightglow -m -s /usr/bin/bash
echo "Downloading templates..."
curl -Lo singbox.json https://github.com/ltgcgo/nightglow/raw/main/warp_sb.json
echo "Registering a new identity..."
nightglow init
nightglow useSocks 20040
echo "Nightglow is now on your device. If you are not using WARP+, you can now safely remove the official WARP client on your device."
exit
