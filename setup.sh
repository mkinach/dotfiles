#!/bin/bash

# setup.sh: automatically configures dotfiles on the system

# redirect stdout and stderr to a log file
LOGFILE="/tmp/setup.log"
exec > >(tee -a "$LOGFILE") 2>&1

# set the trap
ctrl_c() {
	exit 1
}
trap ctrl_c 2 # SIGINT

SCRIPTDIR="$(
	cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
	pwd -P
)"
TMPDIR="${HOME}/tmp"
OPTDIR="${HOME}/opt"
SHAREDIR="${HOME}/.local/share"
CONFIGDIR="${HOME}/.config"

mkdir -p "${OPTDIR}"
mkdir -p "${TMPDIR}"
touch "${TMPDIR}/scratch.txt"
mkdir -p "${TMPDIR}/no-backup"
mkdir -p "${SCRIPTDIR}/tmp/desktop"
touch "${SCRIPTDIR}/tmp/tmp_aliases"
touch "${SCRIPTDIR}/tmp/tmp_bashrc"
touch "${SCRIPTDIR}/tmp/tmp_vimrc"
touch "${SCRIPTDIR}/tmp/tmp_i3"

# check whether necessary software is installed
if ! which vim >/dev/null 2>&1; then
	printf "\n Vim not installed -- skipping.\n"
	SKIP_VIM=1
elif ! which gvim >/dev/null 2>&1 && gvim --version | grep -q +clipboard; then
	printf "\n WARNING: current Vim installation does not support copy-to-clipboard\n"
	printf "            (you may want to install another version, e.g. gvim,\n"
	printf "             if the problem is not fixed after this script finishes).\n"
fi

if ! which i3 >/dev/null 2>&1; then
	printf "\n i3 not installed -- skipping.\n"
	SKIP_I3=1
fi

if ! which dunst >/dev/null 2>&1; then
	printf "\n Dunst not installed -- skipping.\n"
	SKIP_DUNST=1
fi

if ! [ -d "${HOME}/opt/starship" ]; then
	printf "\n Starship not installed -- skipping.\n"
	SKIP_STARSHIP=1
fi

if ! which konsole >/dev/null 2>&1; then
	printf "\n Konsole not installed -- skipping.\n"
	SKIP_KONSOLE=1
fi

# get the list of relevant dotfiles
DOTFILES=($(ls -A "./configs/dotfiles"))

echo
read -r -p "Archive current dotfiles? (Y/n): " ANS_DOTFILES
case "${ANS_DOTFILES}" in
Y)
	for DOTFILE in "${DOTFILES[@]}"; do
		cp "${HOME}/${DOTFILE}" "${HOME}/${DOTFILE}.O" >/dev/null 2>&1
	done

	[[ -z "${SKIP_VIM}" ]] && cp "${HOME}/.vimrc" "${HOME}/.vimrc.O" >/dev/null 2>&1

	[[ -z "${SKIP_I3}" ]] && rm -rf "${CONFIGDIR}/i3.O" >/dev/null 2>&1 &&
		cp -rL "${CONFIGDIR}/i3" \
			"${CONFIGDIR}/i3.O" >/dev/null 2>&1

	[[ -z "${SKIP_DUNST}" ]] && rm -rf "${CONFIGDIR}/dunst.O" &&
		cp -rL "${CONFIGDIR}/dunst" "${CONFIGDIR}/dunst.O" >/dev/null 2>&1

	[[ -z "${SKIP_STARSHIP}" ]] && cp "${CONFIGDIR}/starship.toml" \
		"${CONFIGDIR}/starship.toml.O" >/dev/null 2>&1

	if [[ -z "${SKIP_KONSOLE}" ]]; then
		rm -rf "${SHAREDIR}/konsole.O" >/dev/null 2>&1
		cp -rL "${SHAREDIR}/konsole" "${SHAREDIR}/konsole.O" >/dev/null 2>&1
		cp "${CONFIGDIR}/konsolerc" "${CONFIGDIR}/konsolerc.O" >/dev/null 2>&1
	fi
	;;
esac

# link new dotfiles
for DOTFILE in "${DOTFILES[@]}"; do
	ln -sf "${SCRIPTDIR}/configs/dotfiles/${DOTFILE}" "${HOME}/${DOTFILE}"
done

if [[ -z "${SKIP_VIM}" ]]; then
	ln -sf "${SCRIPTDIR}/configs/vim/.vimrc" "${HOME}/.vimrc"
	[ ! -d ~/.vim/bundle/Vundle.vim ] && git clone https://github.com/gmarik/Vundle.vim.git \
		~/.vim/bundle/Vundle.vim
	gvim -v +PluginInstall +qall &&
		ln -sf "${SCRIPTDIR}/configs/vim/mpk.vim" \
			"${HOME}/.vim/bundle/vim-airline-themes/autoload/airline/themes/mpk.vim"
  [ -d "${HOME}/.vim/bundle/vimspector" ] &&
    mkdir -p "${HOME}/.vim/bundle/vimspector/configurations/linux/_all" &&
      ln -sf "${SCRIPTDIR}/configs/vim/.vimspector.json_python" \
        "${HOME}/.vim/bundle/vimspector/configurations/linux/_all/python.json" &&
      ln -sf "${SCRIPTDIR}/configs/vim/.vimspector.json_bash" \
        "${HOME}/.vim/bundle/vimspector/configurations/linux/_all/bash.json"
	gvim -v +VimspectorInstall +qall
  [ -d "${HOME}/.vim/bundle/YouCompleteMe" ] &&
    ln -sf "${SCRIPTDIR}/configs/vim/.YouCompleteMe.global_extra_conf.py" \
      "${HOME}/.vim/bundle/YouCompleteMe/global_extra_conf.py"
  cd "${HOME}/.vim/bundle/YouCompleteMe" && CC=clang CXX=clang++ python3 install.py --clangd-completer
	mkdir -p "${HOME}/.vim/undo"
fi

[[ -z "${SKIP_I3}" ]] && rm -rf "${CONFIGDIR}/i3" >/dev/null 2>&1 &&
	ln -sf "${SCRIPTDIR}/configs/i3" "${CONFIGDIR}/i3"

[[ -z "${SKIP_DUNST}" ]] && rm -rf "${CONFIGDIR}/dunst" >/dev/null 2>&1 &&
	ln -sf "${SCRIPTDIR}/configs/dunst" "${CONFIGDIR}/dunst"

[[ -z "${SKIP_STARSHIP}" ]] && ln -sf "${SCRIPTDIR}/configs/starship/starship.toml" \
	"${CONFIGDIR}/starship.toml"

if [[ -z "${SKIP_KONSOLE}" ]]; then
	rm -rf "${SHAREDIR}/konsole" >/dev/null 2>&1
	ln -sf "${SCRIPTDIR}/configs/konsole" "${SHAREDIR}/konsole"
	cp "${SCRIPTDIR}/configs/konsole/konsolerc" "${CONFIGDIR}/konsolerc"
fi

# link custom .desktop files
rm -rf "${SHAREDIR}/applications" >/dev/null 2>&1
ln -sf "${SCRIPTDIR}/tmp/desktop" "${SHAREDIR}/applications"

echo
