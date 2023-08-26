#! /bin/bash

# install.sh: automatically installs necessary software

read -r -p "Update the entire system? (Y/n): " ANS_UPDATE
case ${ANS_UPDATE} in
  Y) sudo apt -y update
     sudo apt -y upgrade
     ;;
  *) ;;
esac

while read -r package; do
    sudo apt install -y "$package"
done < pkgs_ubuntu.txt

# install starship
wget -P /tmp https://starship.rs/install.sh && mkdir -p ${HOME}/opt/starship && sh /tmp/install.sh -y -b ${HOME}/opt/starship
