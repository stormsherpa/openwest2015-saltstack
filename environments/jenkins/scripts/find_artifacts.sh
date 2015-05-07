#!/bin/bash

find_artifacts(){
    artifactname=$1
    searchpath=$2
    artifacts="$artifactname: --select--"
    for a in `find $searchpath -name "$artifactname-*.tar.gz" |sort -r |head -n 50`; do
        artifacts="$artifacts,`basename $a`"
    done
    echo $artifacts
}


if [ "x$1" == "x" ]; then
    for app in Mezzapp; do
    find_artifacts $app /var/lib/jenkins/jobs/$app/builds/
    done
else
    find /var/lib/jenkins/jobs/$1/builds/ -name "$1-*.tar.gz" | grep "$2"
fi


