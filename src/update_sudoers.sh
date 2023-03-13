#!/bin/bash

# Set global variables
COLOR_GRAY="\e[1;30m"
STYLE_CLEAR="\e[0m"

FILE="/etc/sudoers.d/wheel"
LINE_EXIST=0

# create file if not exist
if [[ ! -f "$FILE" ]]; then
    touch "$FILE"
    echo -e "$COLOR_GRAY--> create file to wheel setup sudoers$STYLE_CLEAR"
else
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == "%wheel ALL="*"ALL" ]]; then
            LINE_EXIST=1
            echo -e "$COLOR_GRAY--> wheel line of setup sudoers file exist$STYLE_CLEAR"
        fi
    done < "$FILE"
fi

if [[ $LINE_EXIST -eq 0 ]]; then
    echo "%wheel ALL=(ALL:ALL) ALL" >> "$FILE"
    echo -e "$COLOR_GRAY--> set wheel line in setup sudoers file$STYLE_CLEAR"
fi
