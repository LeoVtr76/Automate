#!/bin/bash

for i in "$@" 
do
case $i in 
    f=*)
        FOLDER="${i#*=}"
    ;;
esac
done

echo $FOLDER
cd $FOLDER
ls -l

exit