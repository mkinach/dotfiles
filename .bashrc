# define your custom aliases in a different file
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash
HISTSIZE=1000
HISTFILESIZE=2000

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# color the ls output
alias ls='ls --color'

#----------------------------------------------------------------------

# for adding vi keyboard bindings to the terminal
set -o vi

# map Capslock to ESC
setxkbmap -option caps:escape

# changes bash autocomplete behaviour on Tab press
bind "TAB:menu-complete"
bind '"\e[Z": menu-complete-backward'
bind "set show-all-if-ambiguous on"

# create a colored prompt (see http://bashrcgenerator.com/)
# color syntax is bgcolor;bold;textcolor where bold can be 0,1
# and textcolor can be 3# or 9#, where # goes from 0 to 9
export PS1="\[$(tput sgr0)\]\[\033[0;0;35m\]\u@\h\[$(tput sgr0)\] [\[$(tput sgr0)\]\[\033[0;0;33m\]\w\[$(tput sgr0)\]]\\$ \[$(tput sgr0)\]"

# fix for terminal display issues when resizing window
shopt -s checkwinsize

