base_file="$1"
description="$2"

datetime_ns="$(date --rfc-3339=ns)"

datetime_nsfmt="$(printf '%s\n' "$datetime_ns" | sed -e 's/://g' -e 's/\./_/g' -e 's/ /t/g' -e 's/-/ /g;s/ /-/3g' -e 's/ //g' -e 's/-/m/g')"

help()
{
	# display help
	printf '%s\n' "add description of the script functions here."
	printf '%s\n'
	printf '%s\n' "syntax: script template [-h|f|l]"
	printf '%s\n' "options:"
	printf '%s\n' "h     print this help."
	printf '%s\n'
}

while getopts ":f:h:k:" options; do
	case "${options}" in
		f) # run full script to rename directories and files
			base_file=${OPTARG}
			;;
		h) # display help
			help
			exit 0
			;;
#		k) # kof
#			base_dir=${OPTARG}
#			;;
	esac
done

if [[ "$base_file" == "" ]]; then
	exit 0
else
	files_desc="/users/juancho/frfx/pag/files_description.md"
	pages_file="/users/juancho/frfx/pag/x1_$datetime_nsfmt"
	if [[ ! -f "$files_desc" ]]; then
		touch "$files_desc"
		chown juancho:juancho "$files_desc"
	fi
	printf '%s	- %s\n' "$pages_file" "$2" >> "$files_desc"
	mv -v "$base_file" "$pages_file"
	sed -i -e 's/|/\n/g' -e 's/^[[:blank:]]*$//g' "$pages_file"
fi
