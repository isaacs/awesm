#!/bin/bash

dir=`dirname $0`

base_url=http://create.awe.sm/url.json

# configs
#override these settings in awe.conf
api_key=6c8b1a212434c2153c2f2c2f2c165a36140add243bf6eae876345f8fd11045d3
version=1
share_type=other
create_type=shell_script
callback=

[ -f $dir/awe.conf ] && . $dir/awe.conf

target="$1"
if [ "$target" == "" ]; then
	echo "Usage: $0 <url>"
	exit 1
fi

# verify that the target is valid by making a HEAD request to it.
valid=$( curl -I "$target" 2>/dev/null | head -n1 | egrep -o "^HTTP/1.1 200" )
if ! [ "$valid" == "HTTP/1.1 200" ]; then
	echo "Looks like $target isn't a valid site on the interwho."
	exit 1
fi

postdata=""
for i in callback target version share_type create_type api_key; do
	postdata="$postdata&$i=$( eval 'echo $'"$i" )"
done
postdata=${postdata:1}

# do it.
curl -i -d "$postdata" $base_url