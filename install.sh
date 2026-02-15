#! /bin/bash

# install.sh: automatically installs necessary software

# redirect stdout and stderr to a log file
LOGFILE="/tmp/install.log"
exec > >(tee -a "$LOGFILE") 2>&1

# get distro name (stored in $ID)
source /etc/os-release

read -r -p "Update the entire system? (Y/n): " ANS_UPDATE
case ${ANS_UPDATE} in
Y) case ${ID} in
	ubuntu)
		sudo apt-get -y update
		sudo apt-get -y upgrade
		;;
	*) ;;
	esac ;;
*) ;;
esac

read -r -p "Install system packages? (Y/n): " ANS_SYSTEM
case ${ANS_SYSTEM} in
Y) case ${ID} in
	ubuntu)
		while read -r PACKAGE; do
			# ignore empty lines and comments
			[[ -z "${PACKAGE}" || "${PACKAGE}" =~ ^# ]] && continue
			sudo apt-get install -y "${PACKAGE}"
		done <pkgs_ubuntu.txt

		if command -v pipx &>/dev/null; then
			while read -r PACKAGE; do
				# ignore empty lines and comments
				[[ -z "${PACKAGE}" || "${PACKAGE}" =~ ^# ]] && continue
				pipx install "${PACKAGE}"
			done <pkgs_pipx.txt
		fi
		;;
	*) ;;
	esac ;;
*) ;;
esac

read -r -p "Install Starship? (Y/n): " ANS_STARSHIP
case ${ANS_STARSHIP} in
Y) wget -P /tmp https://starship.rs/install.sh && mkdir -p "${HOME}/opt/starship" && sh /tmp/install.sh -y -b "${HOME}/opt/starship" ;;
*) ;;
esac

read -r -p "Install Ollama? (Y/n): " ANS_OLLAMA
case ${ANS_OLLAMA} in
Y) curl -fsSL https://ollama.com/install.sh | sh && ollama pull phi3:mini ;;
*) ;;
esac
