#!/bin/sh

# ssh(1) to nc(1) wrapper for nsftp
# Copyright 2015-2017 Rivoreo
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

port=2122
verbose=0
#options=
while getopts "1246ab:c:e:fgi:kl:m:no:p:qstvxACD:F:I:KL:MNO:PR:S:TVw:W:XYy" c
do case $c in
	p)
		port="$OPTARG"
		;;
	o)
		#options="`echo \"$OPTARG\" | "
		[ -z "`echo \"$OPTARG\" | sed 's/[[:space:]]//g'`" ] && continue
		if ! echo "$OPTARG" | grep -Eq '^[0-9A-Za-z]+(=|[[:space:]])[0-9A-Za-z_,./]+$'; then
			echo "Bad configuration option: $OPTARG" 1>&2
			exit 255
		fi
		key="`echo \"$OPTARG\" | sed -r 's/(=|[[:space:]])[0-9A-Za-z_,./]+//' | sed y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/`"
		value="`echo \"$OPTARG\" | sed -r 's/[0-9A-Za-z]+(=|[[:space:]])//'`"
		eval "$key=$value" 1>&2
		;;
	v)
		verbose=$((verbose+1))
		;;
	V)
		echo "ssh(1) to nc(1) wrapper" 1>&2
		echo "Warning: this program uses nc(1) to transfer data unencrypted" 1>&2
		exit
		;;
	\?)
		echo "See ssh(1) for acceptable options" 1>&2
		exit 255
		;;
esac done
eval "$options"
shift $((OPTIND-1))
if [ $# -lt 1 ]; then
	echo "Need a host to connect"
	exit 1
fi
#[ $verbose -gt 0 ] && echo "Connecting to $1:$port" 1>&2
[ $verbose -gt 1 ] && echo "Connecting to [$1]:$port" 1>&2
if [ -n "$loglevel" ] && [ "$verbose" = 0 ]
then case "`printf %s \"$loglevel\" | sed y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/`" in
	quiet)
		exec 2> /dev/null
		;;
	fatal|error|info|verbose)
		;;
	debug|debug1)
		verbose=1
		;;
	debug2)
		verbose=2
		;;
	debug3)
		verbose=3
		;;
	*)
		printf "unsupported log level '%s'\\n" "$loglevel" 1>&2
		exit 255
esac fi
opt_v=
while [ $verbose -gt 0 ]; do
	opt_v="$opt_v -v"
	verbose=$((verbose-1))
done
#echo nc $opt_v -- "$1" "$port" 1>&2
nc -q 1 $opt_v -- "$1" "$port"
