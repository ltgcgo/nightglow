#!/bin/bash
cd $PREFIX/opt/nightglow/

function showHelp {
	case "$1" in
		"init" | "register" | "update" | "delSocks" | "help")
			echo "No further help is available."
			;;
		"useSocks")
			echo "Connects to Cloudflare WARP in SOCKS5 mode."
			echo "Usage: nightglow useSocks [port] [username] [password]"
			echo "Port defaults to 20040."
			;;
		"useTun")
			echo "Connects to Cloudflarw WARP using a WireGuard TUN interface."
			echo "Usage: nightglow useTun [configName]"
			echo "Configuration name defaults to \"nightglow\"."
			;;
		"delTun")
			echo "Disconnects from Cloudflare WARP if using WireGuard TUN."
			echo "Usage: nightglow delTun [configName]"
			echo "Configuration name defaults to \"nightglow\"."
			;;
		*)
			echo "  help     Display help. Several subcommands have further help available."
			echo "  init     Initialize a Nightglow installation."
			echo "  register Registers a new Cloudflare WARP account."
			echo "  update   Prepare Cloudflare WARP configurations for connection."
			echo "  useSocks Connects to Cloudflare WARP in SOCKS5 mode."
			echo "  delSocks Disconnects from Cloudflare WARP when in SOCKS5 mode."
			echo "  useTun   Connects to Cloudflarw WARP using a WireGuard TUN interface."
			echo "  delTun   Disconnects from Cloudflare WARP if using WireGuard TUN."
			;;
	esac
}
function register {
	wgcf register --config "nightglow-account.toml"
	chown nightglow nightglow-account.toml
	chgrp nightglow nightglow-account.toml
	wgcf generate --config "nightglow-account.toml" --profile "nightglow.conf"
	chown nightglow nightglow.conf
	chgrp nightglow nightglow.conf
}
function update {
	echo "Not implemented."
}
function registerService {
	echo "Registering a new service..."
	targetSvc=$PREFIX/lib/systemd/system/nightglow.service
	echo "[Unit]" > $targetSvc
	echo "Description=Nightglow SOCKS5 configuration helper" >> $targetSvc
	echo "Wants=network.target" >> $targetSvc
	echo "After=syslog.target network-online.target" >> $targetSvc
	echo " " >> $targetSvc
	echo "[Service]" >> $targetSvc
	echo "Type=simple" >> $targetSvc
	echo "User=nightglow" >> $targetSvc
	echo "Group=nightglow" >> $targetSvc
	echo "ExecStart=wireproxy -c \"$PREFIX/opt/nightglow/socks5.conf\"" >> $targetSvc
	echo "TimeoutStopSec=5s" >> $targetSvc
	echo "Restart=on-failure" >> $targetSvc
	echo "RestartSec=10" >> $targetSvc
	echo "KillMode=process" >> $targetSvc
	echo " " >> $targetSvc
	echo "[Install]" >> $targetSvc
	echo "WantedBy=multi-user.target" >> $targetSvc
	systemctl daemon-reload
	systemctl enable nightglow
}
function useTun {
	echo "Routing not available yet."
	exit 1
	echo "Allowing normal inbound..."
	#PostUp = ip -4 rule add from (public facing IP address) lookup main
	#PostDown = ip -4 rule delete from (public facing IP address) lookup main
	#PostUp = ip -6 rule add from (public facing IP address) lookup main
	#PostDown = ip -6 rule delete from (public facing IP address) lookup main
	echo "Connecting to WARP via WireGuard..."
	#cat nightglow.conf > $PREFIX/etc/wireguard/${1:-nightglow}.conf
	#systemctl enable --now wg-quick@${1:-nightglow}
}
function delTun {
	echo "Disconnecting from WARP..."
	wg-quick down ${1:-nightglow}
	systemctl disable ${1:-nightglow}
	rm $PREFIX/etc/wireguard/${1:-nightglow}.conf
}
function useSocks {
	echo "Connecting to WARP via SOCKS5..."
	cat nightglow.conf > socks5.conf
	chown nightglow socks5.conf
	chgrp nightglow socks5.conf
	echo " " >> socks5.conf
	echo "[Socks5]" >> socks5.conf
	echo "BindAddress = 127.0.0.1:${1:-20040}" >> socks5.conf
	if [ "$2" != "" ] ; then
		echo "Username = ${2}" >> socks5.conf
	fi
	if [ "$3" != "" ] ; then
		echo "Password = ${3}" >> socks5.conf
	fi
	if [ -e "$PREFIX/lib/systemd/system/nightglow.service" ] ; then
		echo "Skipped daemon registration."
	else
		registerService
	fi
	systemctl restart nightglow
}
function delSocks {
	echo "Disconnecting from WARP..."
	systemctl stop nightglow
	systemctl disable nightglow
	rm $PREFIX/lib/systemd/system/nightglow.service
}

ngVer=0.1
echo "Nightglow v${ngVer}"
echo ""
case "$1" in
	"help")
		showHelp "$2"
		;;
	"register")
		register
		;;
	"update")
		update
		;;
	"init")
		if [ -e "./nightglow-account.toml" ] ; then
			echo "Skipping account creation."
		else
			register
		fi
		;;
	"useSocks")
		useSocks "$2" "$3" "$4"
		;;
	"delSocks")
		delSocks
		;;
	"useTun")
		useTun "$2"
		;;
	"delTun")
		delTun "$2"
		;;
	*)
		echo 'Use "nightglow help" for help. Remember to use root.'
		;;
esac
exit
