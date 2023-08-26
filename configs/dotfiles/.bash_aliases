#######################################################################
# Basic Shorthand Aliases for Scripts, Software and Files
#######################################################################

terminal="konsole"

alias {v,vi,vim}='gvim -v'
alias {r,vir,vimr}='vim -R'
alias {vd,vid}='vim .'
alias svi='sudo -E vim'
alias mysudo='sudo -E env "PATH=$PATH"'
alias please='sudo'
alias l='ls --color -F'
alias ls='ls --color -F'
alias la='ls -alh'
alias lh='ls -dlhF .* | grep -v "^d"' # hidden files only
alias lls='ls'  # common typo
alias rp='realpath'
alias rs='source ~/.profile'
alias diff='diff --color'
alias hi='history'
alias dul='du -ahx --max-depth=1 . | sort -k1 -rh | tac' # list and sort
alias dula='du -ahx . | sort -k1 -rh | tac'              # list and sort (recursive)
alias opwd='${terminal} pwd & disown'
alias p='python'
alias sc='screen -q -S 1'
alias sls='screen -ls'
alias sr='screen -d -RR'
alias ksj='kill -9 `jobs -ps`'
alias top='htop'
alias wget-site='wget -k -r --no-parent -nd -e robots=off'
alias nloade='nload -a 60 devices enp920 -u m -i 20000 -o 2000'
alias nloadw='nload -a 60 devices wlp8s0 -u m -i 20000 -o 2000'
alias temp='watch -n 1 sensors'
alias tempgpu='watch -n 5 nvidia-smi -q -d temperature'
alias scratch='vim ~/tmp/scratch.txt'

alias gl='git log'
alias glp='git log --oneline --decorate --graph --all'
alias gs='git status'
alias gsv='git status --verbose'
alias gd='git diff'
alias gdt='git difftool'
alias gt='git ls-tree -r HEAD --name-only'
function gsh { [ $# -eq 2 ] && git show ${1}:${2} > /tmp/${1}_${2} && vim /tmp/${1}_${2}; }

alias bashrc='vim ~/.bashrc'
alias aliases='vim ~/.bash_aliases'
alias vimrc='vim ~/.vimrc'

alias python='python3'

# initialize conda
py() {
  source ~/opt/miniconda/initialize.sh  # initialize

  if [ $# -gt 1 ]; then
    echo "Error: Too many arguments; expected 0 or 1 argument."
    exit 1
  fi

  if [ $# -eq 0 ]; then
    conda activate
    echo "Activated conda environment: base"
  else
    conda activate $1  # activate named env
    echo "Activated conda environment: $1"
  fi
}

# activate non-base conda environments
alias pya='conda activate'
# deactivate a conda environment
alias pyd='conda deactivate'
# list conda environments
alias pyl='conda info --envs'
# create a conda environment
alias pyc='conda create --name'
# remove a conda environment
pyr() {
  conda remove --name $1 --all
}
# save conda environment
alias pys='conda list -e > requirements_conda.txt; pip list --format=freeze > requirements_pip.txt'

# trick to remember cd history
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
alias pd='popd'
alias dirs='dirs -v'

# copy working directory to clipboard
alias pwdc="pwd | tr -d '\n' | xclip -sel c && printf '✓ COPY TO CLIPBOARD SUCCESSFUL\n' && pwd"

# temporarily change konsole colors
if [[ "${terminal}" == "konsole" ]]
then
  alias mpk='konsoleprofile colors=mpk'
  alias black='konsoleprofile colors=WhiteOnBlack'
  alias solar='konsoleprofile colors=Solarized'
  alias red='konsoleprofile colors=RedOnBlack'
fi

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

# search packages by name
pkgs() {
  printf "\n\e[01;33m Available from repositories:  \e[0m\n\n"
  apt search "$1";
  printf "\n\n\e[01;33m Installed:  \e[0m\n\n"
  apt list --installed | grep "$1"
  printf "\n\n"
  }

# list package version
alias pkgsv='apt policy'

# get info on default program associated with file
# (see https://unix.stackexchange.com/a/107508)
defapp() {
  if [[ $# -eq 0 ]] ; then
    printf "\n Syntax: defapp [file]\n\n"
    return
  fi
  ftype=`xdg-mime query filetype $1`
  dapp=`xdg-mime query default $ftype`
  pathdapp=`locate -i $dapp`
  printf "\n File $1 is of type $ftype \n"
  printf " Filetype $ftype is associated with program $dapp \n"
  printf " Program desktop file $dapp is located in:\n$pathdapp \n\n"
  mimes=`locate mimeinfo.cache | wc -l`
  if [ $mimes -ge 2 ]; then
    printf " WARNING: potentially conflicting mimeinfo.cache:\n"
    locate  mimeinfo.cache
  fi
  }

# associate filetype with program via .desktop file
sdefapp() {
  if [[ $# -eq 0 ]] ; then
    printf "\n Syntax: sdefapp [file.desktop] [file]\n\n"
    return
  fi
  xdg-mime default $1 $2
  }

# open file in system default application
op() {
  for var in "$@"
  do
    xdg-open "$var" >/dev/null 2>&1 &
  done
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

# copy directory contents except for files matching pattern
cp-excl(){
  case $# in
    3) ;;
    *) echo " Syntax: cp-excl <source-dir> <dest-dir> <excl-pattern>"; return 1;;
  esac
  if [ -d "$1" ]; then
    rsync -av --exclude "$3" $1/ $2/
  else
    echo " Error: second and third argument are not directories"; return 1
  fi
}

# untar a file
utar() {
  case $# in
    1) ;;
    *) echo " Error: please provide only one tarball!"; return 1;;
  esac
  filepath="$(dirname "$1")"
  filename="$(basename "$1")"
  if [[ $filename == *.tar.gz ]]; then
    filestring=${filename%???????}
    mkdir -p ${filepath}/${filestring}
    tar xvzf "${1}" -C "${filepath}/${filestring}"
  elif [[ $filename == *.tar.bz2 ]]; then
    filestring=${filename%????????}
    mkdir -p ${filepath}/${filestring}
    tar xvjf "${1}" -C "${filepath}/${filestring}"
  fi 
}

# unzip a file
uzip() {  # name of function must not clash with standard 'unzip' command!
  case $# in
    1) ;;
    *) echo " Error: please provide only one zip file!"; return 1;;
  esac
  filepath="$(dirname "$1")"
  filename="$(basename "$1")"
  if [[ $filename == *.zip ]]; then
    filestring=${filename%????}
    mkdir -p ${filepath}/${filestring}
    unzip "${1}" -d "${filepath}/${filestring}"
  fi 
}

# zip up a file
zipup() {
  case $# in
    1) ;;
    *) echo " Error: please provide only one directory to zip!"; return 1;;
  esac
  filepath="$(dirname "$1")"
  filename="$(basename "$1")"
  if [[ -d $filename ]]; then
    zip -r "${filename}.zip" "${filename}"
  fi
}
