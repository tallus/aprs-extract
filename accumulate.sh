#!/bin/bash
# this file has the following standard layout
# CONFIGURATION
# help function
# INCLUDES
#FUNCTIONS
# process option arguments
# MAIN

# CONFIGURATION

help(){
cat <<EOF 

usage: $0 [OPTION]...
This is the summary of what this script does.
	
-h			prints this message

This is a bash script. This part is a longer explanation of what it does. 
EOF

    # if $1 exists and is a number 0..255 return that otherwise return 0
    if [[ -n $1 && $(echo {0..255}) =~ $1 ]]; then
            exit $1
    else
            exit 0
    fi
}
# INCLUDES
#FUNCTIONS

# process option arguments
while getopts "hd:n:" option; do		# w: place variable following w in $OPTARG
	case "$option" in
		h) help;;
        d) dirlist=$OPTARG;;
        n) name=$OPTARG;;
		[?])  echo "bad option supplied" ; 
			help;;	
	esac
done

#MAIN
if [[ ! $name ]]; then
    name="all-acc.json"
fi
list=""
for i in $dirlist; do
    for file in $i/*.json; do
        list="$list $file"
    done
done

python accumulator.py $list >$name
