#!/bin/bash
# shx Standard Utility
if [ -e "$(which nix-shell)" ]; then
	useNix=${1:-env}
	if [ -f "nix/${useNix}.nix" ]; then
		echo "Preparing Nix shell with: ${useNix}.nix..."
		nix-shell nix/${useNix}.nix --quiet --pure --command zsh
		echo "Quitting Nix shell..."
		rm nix/zsh/.zcompdump
	else
		echo "${useNix}.nix does not exist."
	fi
else
	echo "Nix Shell is not available."
fi
exit