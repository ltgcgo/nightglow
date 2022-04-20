#!/bin/bash
use ./wgcf.sh
use ./wireproxy.sh
use ./registerService.sh
use ./newIdentity.sh
echo "Updating helper script..."
mkdir -p $PREFIX/opt/nightglow
cd $PREFIX/opt/nightglow
curl -Lo nightglow.sh https://github.com/ltgcgo/nightglow/raw/main/nightglow.sh
chmod +x nightglow.sh
ln -s $PREFIX/opt/nightglow/nightglow.sh $PREFIX/bin/nightglow
echo "Nightglow is now on your device. If you are not using WARP+, you can now safely remove the official WARP client on your device."
exit
