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
        echo -e "\n$COLOR_GRAY--> Setting setup sudoers file"
        sudo "./$file_update_sudoers"
    else
        echo -e "\n$COLOR_GRAY--> $file_update_sudoers, directory not found$STYLE_CLEAR"
        exit 1
    fi

    file_set_parallel_downloads="./set_parallel_downloads.sh"
    sudo "./$file_set_parallel_downloads"

    echo -e "\n$COLOR_BLUE>> Add default user$STYLE_CLEAR"
    read -p "USER: " newuser
    useradd -m -G wheel -s /bin/bash $newuser
fi
