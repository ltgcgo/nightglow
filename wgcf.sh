#!/bin/bash
appVer="2.2.16"
echo "Detecting device architecture..."
debArch=$(uname -m)
transArch=$debArch
case $debArch in
	"i386" | "i686")
		transArch=386
		;;
	"x86_64" | "amd64")
		transArch=amd64
		;;
	"arm64" | "armv8l" | "aarch64")
		transArch="arm64"
		;;
esac
echo "Installing WGCF on your device..."
mkdir -p $PREFIX/opt/wgcf
cd $PREFIX/opt/wgcf
curl -Lo wgcf "https://github.com/ViRb3/wgcf/releases/download/v${appVer}/wgcf_${appVer}_linux_${transArch}" && chmod +x wgcf
ln -s $PREFIX/opt/wgcf/wgcf /bin/wgcf
echo "Installation complete."
exit
