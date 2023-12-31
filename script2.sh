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

if [ ! -d "$FOLDER" ];then
    echo "Le dossier $FOLDER n'existe pas"
    exit
elif [ "$FOLDER" != '' ];then
    printf 'P1'
    cd $FOLDER
    if [ ! -d ".tmp" ];then
        mkdir .tmp
    else
        rm -rf .tmp/*
    fi
    printf '.'
    if [ ! -d "build" ];then
        mkdir build
    else
        rm -rf .build/*
    fi
    printf '.'
    printf 'done [env reasly]\n'
else
    echo 'Aucun dossier spécifié, indiquer f=<nom_du_dossier>'
    exit
fi
for c in *.c;do
    [ -f "$c" ] || break
    avr-gcc -Os -DF_CPU=16000000UL -mmcu=atmega328p -c $c -o .tmp/${c%.*}.o
    filesC="$filesC .tmp/${c%.*}.o"
done
printf 'P3'
avr-gcc -DF_CPU=16000000UL -mmcu=atmega328p $filesC -o build/$FOLDER 2> /dev/null
printf '. done [links]\n'
printf 'P4'
avr-objcopy -O ihex -R .eeprom build/$FOLDER build/$FOLDER.hex
printf '. done [.hex]\n'
printf "Voulez vous commencer le televersement [Y/N] ?"
read -r TELEV
if [[ $TELEV == 'Y' ]];then
    printf "Démarrage du teléversement \n"
    avrdude -F -V -c arduino -p ATMEGA328P -P /dev/tty.usbmodem14301 -b 115200 -U flash:w:build/$FOLDER.hex

else
    printf "Bye\n"
    exit
fi

exit