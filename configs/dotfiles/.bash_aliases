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
alias sk='sudo -k'
alias l='ls --color -F'
alias ls='ls --color -F'
alias la='ls -alh'
alias lh='ls -dlhF .* | grep -v "^d"' # hidden files only
alias lls='ls'                        # common typo
alias rp='realpath'
alias rs='source ~/.bashrc'
alias diff='diff --color'
alias hi='history'
alias dul='du -ahx --max-depth=1 . | sort -k1 -rh | tac' # list and sort
alias dula='du -ahx . | sort -k1 -rh | tac'              # list and sort (recursive)
alias {o,opwd}='${terminal} pwd & disown'
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
alias gdc='git diff --color-words=..'
alias gdt='git difftool'
alias gt='git ls-tree -r HEAD --name-only'
function gsh { [ $# -eq 2 ] && git show "${1}":"${2}" >/tmp/"${1}"_"${2}" && vim /tmp/"${1}"_"${2}"; }
alias gc='git commit'
alias gcm='git commit -m'

alias bashrc='vim ~/.bashrc'
alias {aliases,bash_aliases}='vim ~/.bash_aliases'
alias vimrc='vim ~/.vimrc'

DOTFILES="$(dirname "$(dirname "$(dirname "$(realpath ~/.bashrc)")")")"
alias dotfiles="cd ${DOTFILES}"
alias tmp_bashrc="vim ${DOTFILES}/tmp/tmp_bashrc"
alias tmp_aliases="vim ${DOTFILES}/tmp/tmp_aliases"
alias tmp_vimrc="vim ${DOTFILES}/tmp/tmp_vimrc"
alias tmp_i3="vim ${DOTFILES}/tmp/tmp_i3"
alias i3="cd ${DOTFILES}/configs/i3"
alias prompt="vim ${DOTFILES}/configs/starship/starship.toml"
alias mypyplot="python ${DOTFILES}/scripts/mypyplot.py"

alias python='python3'

# initialize conda environments
function py() {
	source "${HOME}/opt/miniconda/bin/activate" # initialize

	if [ $# -gt 1 ]; then
		echo "Error: too many arguments; expected 0 or 1 argument."
		exit 1
	fi

	if [ $# -eq 0 ]; then
		conda activate && echo "Activated conda environment: base"
	else # activate named env
		conda activate "${1}" && echo "Activated conda environment: ${1}"
	fi
}
# deactivate a conda environment
alias pyd='conda deactivate'
# list conda environments
alias pyl='conda info --envs'
# create a conda environment (note that 'pip' needs to be here to prevent package management issues)
alias pyc='conda create pip --name'
# remove a conda environment
function pyr() {
	conda remove --name "${1}" --all
}
# save conda environment
alias pys='conda list -e > requirements_conda.txt; command pip list --format=freeze > requirements_pip.txt'

# prevent conda installations in the base environment
function pyi() {
	if [[ "${CONDA_DEFAULT_ENV}" == "base" ]]; then
		echo "Error: you are trying to install packages in the base environment (use 'conda install' to bypass)"
	else
		command conda install "$@"
	fi
}

# prevent pip installations outside of non-base conda environment
function pip() {
	if ! command -v pip &>/dev/null; then
		echo "Error: 'pip' is not installed"
		return 1
	fi

	if [[ -z "${CONDA_DEFAULT_ENV}" || "${CONDA_DEFAULT_ENV}" == "base" ]]; then
		echo "Error: not in a valid conda environment (use 'pips' to bypass)"
	else
		command pip "$@"
	fi
}

# bypass the above pip redefinition
alias pips='command pip'

# trick to remember cd history
function cd {
	if [ $# -eq 0 ]; then
		pushd ~ >/dev/null
	elif [ " ${1}" = " -" ]; then
		pushd "${OLDPWD}" >/dev/null
	else
		pushd "$@" >/dev/null
	fi
}
alias pd='popd'
alias dirs='dirs -v'

# copy working directory to clipboard
alias pwdc="pwd | tr -d '\n' | xclip -sel c && printf '✓ COPY TO CLIPBOARD SUCCESSFUL\n' && pwd"

# temporarily change konsole colors
if [[ "${terminal}" == "konsole" ]]; then
	alias mpk='konsoleprofile colors=mpk'
	alias black='konsoleprofile colors=WhiteOnBlack'
	alias solar='konsoleprofile colors=Solarized'
	alias red='konsoleprofile colors=RedOnBlack'
fi

# safer rm
function rm() {
    ls -lRh "$@"
    command rm -I "$@"  # -I only prompts for 3 or fewer input arguments
}

# find a filename containing a string in cwd & all subdirectories
function myfind() {
	if [ $# -ne 1 ]; then
		printf " Error: function requires precisely 1 input argument\n" && return
	fi
	find . -name "*${1}*"
}

# find a file containing a string in cwd & all subdirectories
function myfindstring() {
	grep --color=always -RiHsn "${1}" .
}

# search packages by name
function pkgs() {
	printf "\n\e[01;33m Available from repositories:  \e[0m\n\n"
	apt search "${1}"
	printf "\n\n\e[01;33m Installed:  \e[0m\n\n"
	apt list --installed | grep "${1}"
	printf "\n\n"
}

# list package version
alias pkgsv='apt policy'

# get info on default program associated with file
# (see https://unix.stackexchange.com/a/107508)
function defapp() {
	if [[ $# -eq 0 ]]; then
		printf "\nUsage: defapp [file]\n\n" && return
	fi

	ftype=$(xdg-mime query filetype "$1") || return
	dapp=$(xdg-mime query default "$ftype") || return
	pathdapp=$(locate -i "$dapp" 2>/dev/null | head -n 1 || echo "Not found")

	if [[ -z "$dapp" ]]; then
		printf "No default app for '%s'.\n" "$ftype" && return
	fi

	printf "\nFile: '%s'\nType: '%s'\nApp:  '%s'\nPath: %s\n\n" "$1" "$ftype" "$dapp" "$pathdapp"

	[[ $(locate mimeinfo.cache 2>/dev/null | wc -l) -ge 2 ]] &&
		printf "WARNING: Potentially conflicting mimeinfo.cache files:\n%s\n" "$(locate mimeinfo.cache)"
}

# set default program for files of a given type
alias sdefapp='mimeopen -d'

# open file in system default application
function op() {
	for var in "$@"; do
		nohup xdg-open "${var}" >/dev/null 2>&1 &
	done
}

# locate file, but only within ${HOME}
function locateh() {
	locate "${1}" | grep "${HOME}"
}

# take diff of files over SSH
function diffssh() {
	case $# in
	3) ssh "${1}" "cat ${2}" | diff - "${3}" ;;
	*)
		echo " Syntax: diffssh user@remote_host remote_file.txt local_file.txt"
		return 1
		;;
	esac
}

# swap the names of two files
function swapnames() {
	mv "${1}" "${1}".tmp
	mv "${2}" "${1}"
	mv "${1}".tmp "${2}"
}

# untar a file
function untar() {
	case $# in
	1) ;;
	*)
		echo " Error: please provide only one tarball!"
		return 1
		;;
	esac
	filepath="$(dirname "${1}")"
	filename="$(basename "${1}")"
	if [[ ${filename} == *.tar.gz ]]; then
		filestring="${filename%???????}"
		mkdir -p "${filepath}"/"${filestring}"
		tar xvzf "${1}" -C "${filepath}/${filestring}"
	elif [[ ${filename} == *.tar.bz2 ]]; then
		filestring="${filename%????????}"
		mkdir -p "${filepath}"/"${filestring}"
		tar xvjf "${1}" -C "${filepath}/${filestring}"
	fi
}

# zip up a file
function zipup() {
	case $# in
	1) ;;
	*)
		echo " Error: please provide only one directory to zip!"
		return 1
		;;
	esac
	filepath="$(dirname "${1}")"
	filename="$(basename "${1}")"
	if [[ -d "${filename}" ]]; then
		zip -r "${filename}.zip" "${filename}"
	fi
}
