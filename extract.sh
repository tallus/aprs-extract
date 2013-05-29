#!/bin/bash


#    Copyright Paul Munday 2013

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.



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

usage: $0 [FILES]...
Extracts raw sets for frames from (log) files for later processing

-d [dir]    output files to dir
-f          overwrite existing output files
-l          further split log files into 2 files containg unencoded latlong data, and Mic-E data
-s          split qar files
-h			prints this message

If a file ends in .log it will extract all frames containing qAR or qAr 
into a file where .qar replaces .log in the filename. If it ends in .qar or
the -l option is supplied, it will extract lines matching latitude and longitude
into .latlon file and Mic-E encoded data into a mice file. If the file ends in latlon
or the -s option is given it will perform further processing suitable to run other scripts over.
Otherwise the file is ignored. It will check for the presence of an output file and won't 
overwrite it unless -f is specified.

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

get_qar(){
    local file=$1
    local out=$(get_out 'qar' $file)
    if [[ ! -e $out || $force_overwrite ]];then
        egrep '(qAR|qAr)' $file >$out
    fi
}

get_latlon(){
    local file=$1
    local out=$(get_out 'latlon' $file)
    if [[ ! -e $out || $force_overwrite ]];then
        egrep '(:!|:=|:/|:@)' $file >$out
    fi
}

get_mice(){
    local file=$1
    local out=$(get_out 'mice' $file)
    if [[ ! -e $out || $force_overwrite ]];then
        egrep "(:\'|:\`)" $file >$out
    fi
}

remove_mice(){
    local file=$1
    local out=$(get_out 'll' $file)
    if [[ ! -e $out || $force_overwrite ]];then
        egrep -v "(:\'|:\`)" $file >$out
    fi
}

split_latlon(){
    local file=$1
    local out=$(get_out 'fixed' $file)
    if [[ ! -e $out || $force_overwrite ]];then
        egrep '(:!|:=)' $file >$out
    fi
    out=$(get_out 'stationary' $file)
    if [[ ! -e $out || $force_overwrite ]];then
        grep ':/' $file >$out
    fi
    out=$(get_out 'moving' $file)
    if [[ ! -e $out || $force_overwrite ]];then
        grep ':@' $file >$out
    fi
}

get_out(){
    local ext=$1
    local filename=$2
    local base=$(basename $filename | cut -d. -f1)
    if [[ -n $dest ]]; then
        local output="${dest}/${base}.${ext}"
    else
        local output="${base}.${ext}"
    fi
    echo "$output"
}

# process option arguments
while getopts "hflsd:" option; do		# w: place variable following w in $OPTARG
	case "$option" in
        d) dest=$OPTARG;;
        f) force_overwrite="true";;
        l) latlon="true";;
        s) split="true";;
		h) help;;
		[?])  echo "bad option supplied" ; 
			help;;	
	esac
done
shift $((OPTIND-1))

#MAIN
for file in $@; do
    extension=$(basename $file | cut -d. -f2)
    if [[ $extension == "log" ]]; then
        get_qar $file 
        if [[ $latlon ]];then
            file=$(get_out 'qar' $file)
            get_latlon $file
        fi
        if [[ $split ]]; then
            get_mice $file
            ll=$(get_out 'latlon' $file)
            qar=$(get_out 'qar' $file)
            if [[ -e $ll ]]; then
                split_latlon $ll
            else
                split_latlon $qar
            fi
            get_mice $qar
        fi
    elif [[ $extension == "qar" ]]; then
        get_latlon $file
        get_mice $file
        if [[ $split ]]; then
            split_latlon $file
        fi
    elif [[ $extension == "latlon" ]]; then
            split_latlon $file
    else
        continue
    fi
done
