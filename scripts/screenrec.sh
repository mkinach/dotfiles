#! /bin/bash

# screenrec.sh: record the screen using ffmpeg

# NOTE: This script assumes you have xwininfo, ffmpeg and slop installed

# usage instructions
usage() {
	echo "Usage: $0 [-o output_file] -w|-s"
	echo "Options:"
	echo "  -o <output_file>: Output MP4 file"
	echo "  -w: Record an entire application window"
	echo "  -s: Record a user-specified selection of the screen"
	echo
	echo " Please provide one of -w or -s (but not both)."
	exit 1
}

# checking for installed software
which xwininfo >/dev/null 2>&1 || {
	echo 'xwininfo not found. Exiting.'
	exit 1
}
which ffmpeg >/dev/null 2>&1 || {
	echo 'ffmpeg not found. Exiting.'
	exit 1
}
which slop >/dev/null 2>&1 || {
	echo 'ffmpeg not found. Exiting.'
	exit 1
}

# parse command-line arguments
while getopts "o:ws" OPT; do
	case ${OPT} in

	o) # append .mp4 extension if not provided
		output_file=${OPTARG}
		if [[ ! "${output_file}" == *".mp4" ]]; then output_file="${output_file}.mp4"; fi
		;;

	w) wflag=1 ;;

	s) sflag=1 ;;

	*) usage ;;

	esac
done

# check for either -w or -s (but not both)
if [[ -n "${wflag}" || -n "${sflag}" ]]; then
	if [[ -n "${wflag}" && -n "${sflag}" ]]; then usage; fi
else
	usage
fi

# check for output filename
if [[ -z "${output_file}" ]]; then
	echo
	current_time=$(date +"%Y-%m-%d_%H-%M-%S")
	output_file="output_${current_time}.mp4"
	echo " No output filename provided... Saving to default file: ${output_file}"
	echo
fi

# get relevant screen data
if [[ -n "${wflag}" ]]; then

	echo
	echo " Click on the target window to begin screen recording."
	echo " Press 'q' to stop recording after selecting the target window."
	echo
	xwininfo >/tmp/windata.tmp

	width=$(cat /tmp/windata.tmp | grep Width | cut -d' ' -f4)
	height=$(cat /tmp/windata.tmp | grep Height | cut -d' ' -f4)
	xpos=$(cat /tmp/windata.tmp | grep "Absolute upper-left X" | cut -d' ' -f7)
	ypos=$(cat /tmp/windata.tmp | grep "Absolute upper-left Y" | cut -d' ' -f7)

elif [[ -n "${sflag}" ]]; then

	echo
	echo " Select a target area with your cursor to begin screen recording."
	echo " Press 'q' to stop recording after selecting the target area."
	echo
	slop >/tmp/windata.tmp 2>/dev/null

	width=$(cat /tmp/windata.tmp | cut -d 'x' -f 1)
	height=$(cat /tmp/windata.tmp | cut -d 'x' -f 2 | cut -d '+' -f 1)
	xpos=$(cat /tmp/windata.tmp | cut -d '+' -f 2)
	ypos=$(cat /tmp/windata.tmp | cut -d '+' -f 3)

fi

# check for valid screen selection
if [[ "${height} ${width} ${xpos} ${ypos}" == *-* ]]; then
	echo
	echo "ERROR: Invalid screen selection detected! Is the target area hanging off of the screen?"
	echo
	exit 1
fi

# bug fix since ffmpeg can only handle window resolutions that are (even)x(even)
if [ $((height % 2)) -ne 0 ]; then height=$((height + 1)); fi
if [ $((width % 2)) -ne 0 ]; then width=$((width + 1)); fi

# record the intended area
ffmpeg -f x11grab -video_size "${width}"x"${height}" -framerate 18 -i :0.0+"${xpos}","${ypos}" -vf format=yuv420p "${output_file}" || exit 1
#ffmpeg -f x11grab -video_size "${width}"x"${height}" -framerate 18 -i :0.0+"${xpos}","${ypos}" -vcodec libx264 -b 20000k "${output_file}" || exit 1

echo
echo " File written to ${output_file}"
echo

du -h "./${output_file}"
