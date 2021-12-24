#######################################################################
# Basic Aliases
#######################################################################

alias please='sudo'
alias rs='source ~/.profile'
alias bell='echo -e "\a"'
alias diff='diff --color'
alias hi='history'
alias opwd='x-terminal-emulator pwd & disown'
alias vir='vi -R'
alias sc='screen -q -S 1'
alias sls='screen -ls'
alias sr='screen -d -RR'
alias top='htop'
alias wget-site='wget -k -r --no-parent -nd -e robots=off'
alias temp='watch -n 1 sensors'
alias scratch='mkdir -p ~/tmp; vim ~/tmp/scratch.txt'

#######################################################################
# Functions
#######################################################################

# trick to remember cd history
alias pd='popd'
function cd
{
    if [ $# -eq 0 ]; then
        pushd ~ > /dev/null
    elif [ " $1" = " -" ]; then
        pushd "$OLDPWD" > /dev/null
    else
        pushd "$@" > /dev/null
    fi
}

# find a filename containing a string in cwd & all subdirectories
myfind() {
  err=0;
  if [ $# -ne 1 ]
  then
    err=1;
    printf " Error: function requires precisely 1 input argument\n"
    return;
  fi
  find . -name "*$1*"
}

# find a file containing a string in cwd & all subdirectories
myfindstring() {
  grep --color=always -RiHsn "$1" .
  }

op() {
  xdg-open "$1" >/dev/null 2>&1 &
}

# locate file, but only within $HOME
locateh() {
  locate $1 | grep $HOME
}

# take diff of files over SSH
diffssh() {
  case $# in
    3) ssh $1 "cat $2" | diff - $3;;
    *) echo " Syntax: diffssh user@remote_host remote_file.txt local_file.txt"; return 1;;
  esac
}

# swap the names of two files
swapnames() {
  mv $1 $1.tmp
  mv $2 $1
  mv $1.tmp $2
}
