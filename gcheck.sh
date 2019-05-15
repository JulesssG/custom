#!/bin/bash
# Script that checks the all non-bare repositories present in ~ for dirtiness
# and output all dirty repo if any.
#
# Only check for current branch

repos=""
while read -r line
do
	if [[ -f "${line}/FETCH_HEAD" && -n "$(grep -or 'github.com:JulesssG' "${line}/FETCH_HEAD")" ]]
	then
		cd $line && cd ..
		gs="$(git status -sb)"
		# echo "gs: $gs"
		# echo "wc: $(echo "$gs" | wc -l)"
		# echo "ahead: $(echo "$gs" | grep -o 'ahead')"
		if [[ -n "$(echo "$gs" | grep -o 'ahead')" || $(echo "$gs" | wc -l) > 1 ]]
		then
			repos+="$(echo "$line" | sed 's/\.git//')"
		fi
	fi
done <<< "$(find ~/Documents/EPFL/2018-2019 -name ".git" -type d)"

repos="$(echo "$repos" | sed 's/\/\//\/\n\//g')"

if [[ -n $repos ]]
then
	echo "$(echo "$repos" | wc -l) dirty repo in ~:"
	printf "%s\n" "$repos"
else
	echo "~'s repos are clean!"
fi
