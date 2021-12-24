# dotfiles

My basic set of dotfiles (and other configs) to get up-and-running on a new machine.

### Vim Setup

Make sure you use a version of Vim that is compiled with the `+clipboard` option
```
sudo apt-get install vim vim-gtk
```

Install Vundle and desired plugins using these instructions
```
https://github.com/VundleVim/Vundle.vim
https://www.tomordonez.com/install-plugin-vim/
```

### Konsole Setup

Assuming Konsole (and Vundle plugins) are properly installed, set up colors
```
cp ./mpk.* ~/.local/share/konsole
echo "[KonsoleWindow]" >> ~/.config/konsolerc
echo "ShowMenuBarByDefault=false" >> ~/.config/konsolerc
```

### SSH Setup

Generate the keys on your local machine
```
ssh-keygen -t rsa
```

Push your public key to any server
```
ssh-copy-id -i ~/.ssh/id_rsa.pub user@remoteserver
```

