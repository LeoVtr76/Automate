#!/bin/bash
INIT=1

for i in "$@" 
do
case $i in 
    f=*)
        FOLDER="${i#*=}"
    ;;
    i=*)
        INIT="${i#*=}"
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
        rm -rf build/*
    fi
    printf '.'
    printf 'done [env reasly]\n'
else
    echo 'Aucun dossier spécifié, indiquer f=<nom_du_dossier>'
    exit
fi

if [ "$INIT" == "1" ];then
    printf "INITIALISATION EN COURS\n"
    if [ ! -f "$FOLDER/.arduicesi" ]; then
        touch "$FOLDER/.arduicesi"
    fi
    echo "" > $FOLDER/.arduicesi
    echo "{" >> $FOLDER/.arduicesi
    printf 'Quel type de carte utilisez-vous ? [atmega328p]'
    read -r TYPE
    if [[ $TYPE == '' ]];then
        TYPE="atmega328p"
    fi
    echo ' type: "'$TYPE'",' >> $FOLDER/.arduicesi
    printf 'Quel port utilisez-vous [/dev/ttyS1]'
    read -r PORT
    if [[ $PORT == '' ]];then
        PORT="/dev/ttyS1"
    fi
    echo ' port: "'$PORT'",' >> $FOLDER/.arduicesi
    echo "}" >> $FOLDER/.arduicesi

fi  
CONF_TYPE=$(grep -o 'type: "[^"]*' $FOLDER/.arduicesi | cut -d'"' -f2)
CONF_PORT=$(grep -o 'port: "[^"]*' $FOLDER/.arduicesi | cut -d'"' -f2)

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
    avrdude -F -V -c arduino -p ATMEGA328P -P /deb/ttyS1 -b 115200 -U flash:w:build/$FOLDER.hex

else
    printf "Bye\n"
    exit
fi

exit