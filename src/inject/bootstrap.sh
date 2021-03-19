#!/bin/bash

HEADER_F="$1"
INJECT_F="$2"

shift 2

exec 3< <(for regex in "$@"
do
	echo "$regex"
done)

FX=$(gcc -o /dev/stdout -E "$HEADER_F" | grep -Ev -e '^#' -e '^ *$' | tr -d '\n' | sed -E "s/;/;\\n/g" | sed -E 's/^ +//' | grep -E -f /dev/fd/3)
exec 3<&-

# ----------------------- headers

{
	cat <<EOF
#include "$HEADER_F"

EOF
} > "$INJECT_F"

cat <<EOF
#define _GNU_SOURCE
#include <dlfcn.h>
#include <dlfcn.h>
#include "$HEADER_F"
#include "$INJECT_F"
#include "injtools.h"

EOF

# ----------------------- functions

echo "$FX" | while read func
do
	ret_t=$(echo "$func" | sed -E 's/([^(]+) FT_[^ ]+ *\(.+$/\1/')
	func_n=$(echo "$func" | grep -Eo " FT_[^ (]+ ?\(" | tr -d ' ()')
	args=$(echo "$func" | grep -Eo "\(.*\)")
	
	echo "typedef $ret_t (*orig_"$func_n"_type)$args;" >> "$INJECT_F"
	
	#gen_inject "$ret_t" "$func_n" "$args" >> "$C_FILE"
	args2=$(echo "$args" | sed -E 's/(^\( *)|( *\)$)//g' | grep -vx void | tr , '\n' | tr -d '*&' | grep -Eo '[^ ]+$' | paste -sd , - | xargs printf '(%s)')
	return_is_void=$(echo " $ret_t " | grep " void ")
	
	cat <<EOF
${ret_t} ${func_n}${args}
{
	INJ_dbgprint("> %s\n", "${func_n}");
	
	orig_${func_n}_type orig_${func_n};
	orig_${func_n} = (orig_${func_n}_type)dlsym(RTLD_NEXT,"${func_n}");
EOF

	if [ -n "$return_is_void" ]
	then
		cat <<EOF
	orig_${func_n}${args2};
	
	INJ_dbgprint("<\n");
	
	return;
EOF
	else
		cat <<EOF
	${ret_t} ret = orig_${func_n}${args2};
	
	INJ_dbgprint("< %d\n", ret);
	
	return ret;
EOF
	fi

	cat <<EOF
}
EOF
	
done

exit 0
