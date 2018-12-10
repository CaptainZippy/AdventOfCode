#! /bin/sh

if [ "$#" != 1 ] ; then
    echo "Specify which file to watch"
    exit 1
fi
inotify-hookable -f $1 -c "nim c --run $1"
