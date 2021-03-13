#!/bin/bash

if [ ! -e "$1" ]
then
	exit 1
fi

H_FILE=${2:-"injections.h"}
C_FILE=${3:-/dev/stdout}

function gen_inject
{
	# remove args type for later
	args2=$(echo "$3" | sed -E 's/(^\( *)|( *\)$)//g' | tr , '\n' | tr -d '*&' | grep -Eo '[^ ]+$' | paste -sd , - | xargs printf '(%s)')
	isvoid=$(echo " $1 " | grep " void ")
	
	cat <<EOF
$1 $2$3
{
	INJ_dbgprint("> %s\n", "$2");
	
	orig_$2_type orig_$2;
	orig_$2 = (orig_$2_type)dlsym(RTLD_NEXT,"$2");
EOF

	if [ -n "$isvoid" ]
	then
		cat <<EOF
	orig_$2$args2;
	
	INJ_dbgprint("<\n");
	
	return;
EOF
	else
		cat <<EOF
	$1 ret = orig_$2$args2;
	
	INJ_dbgprint("< %d\n", ret);
	
	return ret;
EOF
	fi

	cat <<EOF
}
EOF

}


{
	cat <<EOF
#include "$1"

EOF
} > "$H_FILE"

{
	cat <<EOF
#define _GNU_SOURCE
#include <dlfcn.h>
#include "$1"
#include "$H_FILE"
#include "injtools.h"

EOF
} > $C_FILE


grep -Ev -e '^ *$' -e '^#' -e '^//' -e '^extern ' ./ftd2xx_fx.h | while read func
do
	ret_t=$(echo "$func" | sed -E 's/([^(]+) FT_[^ ]+ *\(.+$/\1/')
	func_n=$(echo "$func" | grep -Eo " FT_[^ (]+ ?\(" | tr -d ' ()')
	args=$(echo "$func" | grep -Eo "\(.*\)")
	
	echo "typedef $ret_t (*orig_"$func_n"_type)$args;" >> "$H_FILE"
	gen_inject "$ret_t" "$func_n" "$args" >> "$C_FILE"
done