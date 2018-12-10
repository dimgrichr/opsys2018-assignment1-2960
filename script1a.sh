#!/bin/bash
touch checkedUrls.txt
touch neurl.html
cat $1 | while read -s line1; do
	initial=${line1:0:1}
    if [ initial != "#" ] ; then
		touch neurl.html
		> neurl.html
		curl $line1 -L --compressed -s  > neurl.html || echo "$line1 FAILED"
		if ! grep -q "$line1"* checkedUrls.txt ; then
			echo "$line1 INIT"
			echo "$line1 $(md5sum neurl.html | awk '{print $1}')" >> checkedUrls.txt
		else
			cat checkedUrls.txt | while read -s line2; do
				page=$(echo "$line2" | awk '{print $1}')
				if [ "$page" == "$line1" ] ; then
					oldcode=$(echo "$line2" | awk '{print $2}')
					newcode=$(echo "$(md5sum neurl.html | awk '{print $1}')")
					if [ "$newcode" != "$oldcode" ] ; then
						echo "$page"
					fi
				fi
			done
		fi
	fi
done
