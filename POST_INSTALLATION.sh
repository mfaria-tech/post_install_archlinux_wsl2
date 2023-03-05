#!/bin/bash

# Set global variables
COLOR_BLUE="\e[0;34m"
COLOR_GRAY="\e[1;30m"
STYLE_CLEAR="\e[0m"

CURUSER=$(whoami)

# Main instructions
if [[ $CURUSER == "root" ]]; then
    echo -e "$COLOR_BLUE>> Set root password$STYLE_CLEAR"
    passwd

    file_update_sudoers="update_sudoers.sh"
    if [[ -f "$file_update_sudoers" ]]; then
        echo -e "\n$COLOR_GRAY--> Setting setup sudoers file$STYLE_CLEAR"
        sudo "./$file_update_sudoers"
    else
        echo -e "\n$COLOR_GRAY--> $file_update_sudoers, file not found$STYLE_CLEAR"
        exit 1
    fi

    file_set_parallel_downloads="set_parallel_downloads.sh"
    if [[ -f "$file_set_parallel_downloads" ]]; then
        echo -e "\n$COLOR_GRAY--> Setting pacman conf file$STYLE_CLEAR"
        sudo "./$file_set_parallel_downloads"
    else
        echo -e "\n$COLOR_GRAY--> $file_set_parallel_downloads, file not found$STYLE_CLEAR"
        exit 1
    fi

    echo -e "\n$COLOR_BLUE>> Add default user$STYLE_CLEAR"
    read -p "USER: " newuser
    useradd -m -G wheel -s /bin/bash $newuser

    file_key_sign="init_pacman_key.sh"
    if [[ -f "$file_key_sign" ]]; then
        echo -e "\n$COLOR_GRAY--> Initialize pacman key$STYLE_CLEAR"
        sudo "./$file_key_sign"
    else
        echo -e "\n$COLOR_GRAY--> $file_key_sign, file not found$STYLE_CLEAR"
        exit 1
    fi
fi
