#!/bin/bash

if [[ ! -e "$1" ]]
then
	exit 1
fi
filename=$(basename "${1%.*}")
types_f=${2:-"$filename"_types.h}
fx_f=${3:-"$filename"_fx.h}
macro=$(echo "$filename"_TYPES_H | sed -E 's/[^a-zA-Z_]//g' | tr abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ)

cleaned=$(gcc -o /dev/stdout -E "$1" | grep -Ev -e '^#' -e '^ *$' | tr -d '\n' | sed -E "s/;/;\\n/g" | sed -E 's/^ +//')
func=$(echo "$cleaned" | grep '(' | grep -E -e '^FT_STATUS' -e FT_W32_)


echo "#ifndef $macro
#define $macro
" > "$types_f"

exec 3< <(echo "$func")
echo "$cleaned" | grep -Fv -f /dev/fd/3 >> "$types_f"
exec 3<&-

echo "#endif" >> "$types_f"

# further cleaning
func=$(echo "$func" | sort | sed -E 's/ +/ /g' | sed -E 's/ *([(),]) */\1/g')

# merge with existing file
fx_enabled=""
if [ -e "$fx_f" ]
then
	fx_enabled=$(grep -Ev -e '^ *$' -e '^#' -e '^//' "$fx_f" | sed -E 's/^[^(]+ ([^ ]+) *\(.+$/\1(/')
fi

{
	cat <<EOF
#include "$types_f"

EOF
	exec 3< <(echo -n "$fx_enabled")
	echo "$func" | grep -F -f /dev/fd/3
	exec 3< <(echo -n "$fx_enabled")
	echo "$func" | grep -Fv -f /dev/fd/3 | awk '{ print "// "$0 }'
	exec 3<&-
} > "$fx_f"