#!/bin/bash

function dl {
    local url=$1
        #--convert-links \
        #--recursive \
    wget \
        --local-encoding=UTF-8 \
        --no-clobber \
        --page-requisites \
        --html-extension \
        --wait=3 \
        --retry-on-http-error=429,503,504 \
        --domains www.helswingi.fi \
        "$url"
}

function dl-sitemap {
    SITEMAP="https://www.helswingi.fi/sitemap.xml"
    XML=`wget -O - --quiet $SITEMAP`
    URLS=`echo $XML | egrep -o "<loc>[^<>]*</loc>" | sed -e 's:</*loc>::g'`

    for url in $( echo $URLS | tr ' ' '\n' ) ; do
        dl "$url"
    done
}

cat - |while read url
do
    dl "$url"
done
