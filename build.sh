#! /bin/bash

# build.sh: builds Apptainer image for remote clusters

# redirect stdout and stderr to a log file
LOGFILE="/tmp/build.log"
exec > >(tee -a "$LOGFILE") 2>&1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFFILE="${SCRIPT_DIR}/pkgs_apptainer.def"
SIFFILE="${SCRIPT_DIR}/devenv.sif"

if [[ ! -f "${DEFFILE}" ]]; then
	echo "Error: ${DEFFILE} not found"
	exit 1
fi

if ! command -v apptainer &>/dev/null; then
	echo "Error: Apptainer not found"
	exit 1
fi

read -r -p "Build Apptainer image? (Y/n): " ANS_BUILD
case ${ANS_BUILD} in
Y)
	sudo apptainer build "${SIFFILE}" "${DEFFILE}"
	mv "${SIFFILE}" /tmp/
	echo
	;;
*) ;;
esac
