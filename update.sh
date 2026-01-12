#! /bin/bash

# force_update.sh: update local dotfiles to match the remote repo

read -r -p "Overwrite existing dotfiles? Ignored files will be left unchanged (Y/n): " ANS_UPDATE
case ${ANS_UPDATE} in
Y)
	git fetch origin
	git reset --hard origin/main
	;;
*) ;;
esac
