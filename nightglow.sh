#/bin/bash
function showHelp {
	case "$1" in
		"init" | "register" | "update")
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
			echo " help     Display help. Several subcommands have further help available."
			echo " init     Initialize a Nightglow installation."
			echo " register Registers a new Cloudflare WARP account."
			echo " update   Prepare Cloudflare WARP configurations for connection."
			echo " useSocks Connects to Cloudflare WARP in SOCKS5 mode."
			echo " delSocks Disconnects from Cloudflare WARP when in SOCKS5 mode."
			echo " useTun   Connects to Cloudflarw WARP using a WireGuard TUN interface."
			echo " delTun   Disconnects from Cloudflare WARP if using WireGuard TUN."
			;;
	esac
}
function register {
	echo "Not implemented."
}
function update {
	echo "Not implemented."
}

ngVer=0.1
echo "Nightglow v${ngVer}"
echo ""
case "$1" in
	"help")
		showHelp "$2"
		;;
	"register")
		;;
	"update")
		;;
	"init")
		;;
	"useSocks")
		echo "Not implemented."
		;;
	"delSocks")
		echo "Not implemented."
		;;
	"useTun")
		echo "Not implemented."
		;;
	"delTun")
		echo "Not implemented."
		;;
	*)
		echo 'Use "nightglow help" for help. Remember to use root.'
		;;
esac
exit
