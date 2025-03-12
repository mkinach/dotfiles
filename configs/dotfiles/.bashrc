# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

# define your custom aliases in a different file
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# source other bashrc and aliases
DOTFILES_PATH=$(dirname $(dirname $(dirname "$(readlink -f "${BASH_SOURCE}")")))
if [ -f ${DOTFILES_PATH}/tmp/*bashrc ];  then . ${DOTFILES_PATH}/tmp/*bashrc; fi
if [ -f ${DOTFILES_PATH}/tmp/*aliases ]; then . ${DOTFILES_PATH}/tmp/*aliases; fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# add to PATH
export PATH="$PATH:${DOTFILES_PATH}/scripts:${HOME}/.local/bin"

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# for adding vi keyboard bindings to the terminal
# ref: jasoncoffin.com/utilize-vi-keyboard-shortcuts-in-your-terminal/
set -o vi

# map Capslock to ESC
setxkbmap -option caps:escape

# changes bash autocomplete behaviour on Tab press
# https://unix.stackexchange.com/a/55632
# https://unix.stackexchange.com/a/389464
bind "TAB:menu-complete"
bind '"\e[Z": menu-complete-backward'
bind "set show-all-if-ambiguous on"

# fix terminal display issues when resizing window
shopt -s checkwinsize

# create a colored prompt (see http://bashrcgenerator.com/)
# color syntax is bgcolor;bold;textcolor where bold can be 0,1
# and textcolor can be 3# or 9#, where # goes from 0 to 9
#export PS1="\[$(tput sgr0)\]\[\033[0;0;35m\]\u@\h\[$(tput sgr0)\] [\[$(tput sgr0)\]\[\033[0;0;33m\]\w\[$(tput sgr0)\]] \\$ \[$(tput sgr0)\]"

# use starship prompt
eval "$(~/opt/starship/starship init bash)"

# disable any group and other permissions on new files by default
# (this may cause issues if you create files in a shared directory)
#umask 077
