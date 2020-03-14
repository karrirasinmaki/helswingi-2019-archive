#!/bin/bash

function testlineread {
    file="prs-out.txt"
    while IFS=\n read -r f1 f2
    do
        echo "$f1" "$f2"
        echo "...."
    done < "$file"
}

function testsed {
    sedrq='s#\/\?#?#g'
    sedrpath='s#(http:|https:|:|)\/\/([^\.]+\.squarespace[^\/]+)(\/.*)(\/[^\s]*)#ext-assets/\2\4#g'
    sedrhs='s#[\?\=]#-#g'

    out=""
    rows="
http://static1.squarespace.com/static/5cd3e61db91449614c565754/5cdbd028eb3931478b9fa4b3/5ce97b461905f4a0b944ca44/1572699270488/_GH23748.jpg?format=1500w
https://assets.squarespace.com/universal/scripts-compressed/common-20338a78c4c29701996bf-min.en-US.js
"
    while IFS=\n read -r str
    do
        res=$(echo "$str" |sed -E $sedrq |sed -E $sedrpath |sed -E $sedrhs)
        out+=$str' : '$res
        out+='\n'
    done <<< "$rows"
    echo -e $out
}

testlineread

