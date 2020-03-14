#!/bin/bash

teststr="assets.squarespace.com/universal/scripts-compressed/commerce-fdb74f9041e87f4cbd38a-min.en-US.js"
lol="ext-assets/static1.squarespace.com/static/5cd3e61db91449614c565754/t/5ce66ad1104c7bda1750dbb5/1568985506900"

function saveFileSve {
    local url=$1
    local savepath=$2
    (( "${#url}" < 4 )) && return 0
    # ! [[ $url =~ ".js" ]] && return 0

    # if file already exists
    [ -f "$savepath" ] && [ -s "$savepath" ] && echo "exists already, skipping" && return 0

    # if savepath is directory
    # [ -d "$savepath" ] && rm -r "$savepath" && echo "removed"

    curl "$url" -L --create-dirs -o "$savepath"
}

function saveall {
    local inputfile=$1
    local outdir=$2
    #wget -x -i $inputfile --directory-prefix $outdir
    # cat "$inputfile"|sed -E 's#(http:|https:|:|)//##g' |xargs -n 1 -I{} echo "url $outdir/{}"


    # sed -E 's#(http:|https:|:|)//##g' |\
    # sed -E 's#^(.*)(/)([\?\#]+.*|)$#\1\3#g' |\
    # while read line

    while IFS='|' read -r url path
    do
        url=$(echo $url |sed -E 's#^//#https://#g')
        echo "URL: $url"
        # echo "PAT: $outdir$path"
        # echo "---"
        saveFileSve "$url" "$outdir/$path"
    done < "$inputfile"
}

saveall $1 $2
