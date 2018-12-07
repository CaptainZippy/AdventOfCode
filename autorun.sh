#! /bin/sh

if [ "$#" != 1 ] ; then
    echo "Usage $0 <filename>"
    exit 1
fi
case "$1" in
    *.nim) inotify-hookable -f "$1" -c "nim c --run $1";;
    *) echo "Don't know how to handle $1";;
esac

