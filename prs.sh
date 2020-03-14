#!/bin/bash
workdir=$(pwd)
urlfile="$workdir/prs-out.txt"

old_domain="www.helswingi.fi"
new_domain="2019.helswingi.fi"

function tester {
    urlfile="$workdir/prs-test.txt"
    local url="//static1.squarespace.com/static/5cd3e61db91449614c565754/t/5ce66ad1104c7bda1750dbb5/1582726096611/?format=1500w"
    local path=$(urltolocalpath $url)

    echo $url |sed "s#$url#$path#g"
}


function sortuniq {
    local file=$1
    sortedurls=$(sort "$file" |uniq)
    echo -e "$sortedurls" > "$file"
}

function urltolocalpath {
    local url=$1
    sedrq='s#\/\?#?#g'
    sedrpath='s#(http:|https:|:|)\/\/([^\.]+\.squarespace[^\/]+)(\/.*)(\/.*)(\/[^\s]*)#/ext-assets/\2\4\5#g'
    sedrhs='s#[\?\&\=]#-#g'

    res=$(echo "$url" |sed -E $sedrq |sed -E $sedrpath |sed -E $sedrhs)
    echo $res
}

function getfileurls {
    local file=$1
    local tmp="$workdir/urls.tmp.txt" # where to write extracted urls
    cat "$file" |grep -Eo '(http(s|):|:|)//[^\.]+\.squarespace[^\"]+' > "$tmp"
    sortuniq "$tmp"

    # return
    cat "$tmp"
}

function workfile {
    local file=$1
    echo " working on: $file"
    # ext urls
    local urls=$(getfileurls "$file")
    while IFS= read -r url
    do
        local path=$(urltolocalpath "$url")
        sed -i "s#\"$url\"#\"$path\"#g" "$file"
        echo "$url|$path" >> "$urlfile"
    done <<< "$urls"
    # domain
    sed -Ei "s#$old_domain#$new_domain#g" "$file"
}

function workfolder {
    local dir=$1 # current folder

    pushd "$PWD" > /dev/null
    cd "$dir"
    echo "=====^ $PWD ====="
    # recursively loop all folders
    for i in $( ls ) ; do
        if [ -d "$i" ] ; then
            workfolder "$i"
        fi
    done
    # handle file
    for i in $( ls |grep .html ) ; do
        workfile "$PWD/$i"
    done
    popd > /dev/null
    echo "=====v $PWD ====="
}

function dowork {
    local dir=$1 # current folder
    local op=$2

    echo "" > "$urlfile"
    workfolder "$dir" # extract all urls
    sortuniq "$urlfile"
}


# tester
# exit 0

dowork $1 $2







# function workfolder {
#     local dir=$1 # current folder
#     local updir=$2 # prefix upfolders
#     local urloutfile=$3 # where to write extracted urls
# 
#     pushd "$PWD" > /dev/null
#     cd "$dir"
#     echo "$urloutfile"
#     echo "=====^ $PWD ====="
#     for i in $( ls ) ; do
#         if [ -d "$i" ] ; then
#             workfolder "$i" "..\\/$updir" "$urloutfile"
#         fi
#     done
#     for i in $( ls |grep .html ) ; do
#         echo " working on: $PWD/$i"
#         cat $i |grep -Eo '(http(s|):|:|)//[^\.]+\.squarespace[^\"]+' >> $urloutfile
#         sed -Ei 's#(http:|https:|:|)//([^\.]+\.squarespace[^\"]+)#ext-assets/\2#g' $i
#         # sed -Ei 's/data-src="([^\"]+)"/src="\1" data-src="\1"/g' $i
# 
#     done
#     popd > /dev/null
#     echo "=====v $PWD ====="
# }
