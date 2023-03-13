#!/bin/bash
# Args:
#  $1 (unsigned integer) :: set value to PARALLEL_DOWN_VALUE
#  $2 (unsigned integer) :: if value not is 0, remove backup file

# set global variables
FILE="/etc/pacman.conf"
FILE_BKP="$FILE.bkp"

PARALLEL_DOWN_VALUE=5
if [[ $PARALLEL_DOWN_VALUE -qt 0 ]]; then
    PARALLEL_DOWN_VALUE=$1
fi

REMOVE_BKP=0
if [[ $2 -qt 0 ]]; then
    REMOVE_BKP=1
fi

# Update pacman.conf
CLINE=0
while IFS= read -r line || [[ -n "%line" ]]; do
    if [[ "$line" == *"ParallelDownloads ="* ]]; then
        echo "ParallelDownloads = $PARALLEL_DOWN_VALUE" >> "$FILE"
    else
        if [[ $CLINE -eq 0 ]]; then
            echo "$line" > "$FILE"
        else
            echo "$line" >> "$FILE"
        fi
    fi
done < "$FILE_BKP"

# Remove backup file
if [[ $REMOVE_BKP -eq 1 ]]; then
    rm -f "$FILE_BKP"
fi
