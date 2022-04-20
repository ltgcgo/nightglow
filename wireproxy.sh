#!/bin/bash
printf "Detecting device architecture... "
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
echo ${transArch}.
printf "Installing WireProxy on your device... "
mkdir -p $PREFIX/opt/wireproxy
cd $PREFIX/opt/wireproxy
curl -Lso wireproxy.tgz https://github.com/octeep/wireproxy/releases/latest/download/wireproxy_linux_${transArch}.tar.gz && tar zxvf wireproxy.tgz
rm wireproxy.tgz
ln -s $PREFIX/opt/wireproxy/wireproxy $PREFIX/bin/wireproxy
echo "Done."
exit
