#! /bin/bash

# dostuff.sh: iterate through directories listed in a file

# you probably want to write an alias to quickly edit this file
# alias dostuff='vim /path/to/here/dostuff.sh'

# set the trap
ctrl_c() {
	exit 1
}
trap ctrl_c 2 #SIGINT

count=0

case $# in
1)
	while read -r dir; do
		((count++))
		printf "\n %d  Processing %s\n\n" "${count}" "${dir}"

		# do something here!

	done <"${1}"
	;;
*) printf "\nError: please supply one file containing names of directories\n\n" ;;
esac
