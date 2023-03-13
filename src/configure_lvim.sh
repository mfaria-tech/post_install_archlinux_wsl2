#!/bin/bash

COLOR_GRAY="\e[1;30m"
COLOR_GREEN="\e[0;32m"
STYLE_CLEAR="\e[0m"

FILE="$HOME/.config/lvim/config.lua"
FILE_BKP="$FILE.bkp"

OPTS=(
    "vim.opt.timeoutlen"
    "vim.opt.showtabline"
    "vim.opt.tabstop"
    "vim.opt.shiftwidth"
    "vim.opt.expandtab"
)

# --> create backup file
cp $FILE $FILE_BKP

CURLINE=0
VALUE=""

# --> Update opts in file
while IFS= read -r line || [[ -n "$line" ]]; do
    VALUE="$line"
    for opt in "${OPTS[@]}"; do
        if [[ "$line" = *"$opt"* ]] && [[ "$opt" != "" ]]; then
            echo -e "$COLOR_GRAY==> SET OPTION :: $opt$STYLE_CLEAR"
            VALUE="$opt"
            if [[ "$opt" = *"timeoutlen"* ]]; then
                VALUE="$opt = 500"
            elif [[ "$opt" = *"showtabline"* ]] || [[ "$opt" = *"tabstop"* ]] || [[ "$opt" = *"shiftwidth"* ]]; then
                VALUE="$opt = 4"
            elif [[ "$opt" = *"expandtab"* ]]; then
                VALUE="$opt = true"
            fi
            OPTS=( "${OPTS[@]/$opt}" )
        fi
    done

    if [[ $CURLINE -eq 0 ]]; then
        echo "$VALUE" > $FILE
    else
        echo "$VALUE" >> $FILE
    fi

    CURLINE=$(( $CURLINE + 1 ))
done < "$FILE_BKP"

# --> Add opts in new line file
for opt in "${OPTS[@]}"; do
    if [[ "$opt" != "" ]]; then
        VALUE="$opt"
        if [[ "$opt" = *"timeoutlen"* ]]; then
            VALUE="$opt = 500"
        elif [[ "$opt" = *"showtabline"* ]] || [[ "$opt" = *"tabstop"* ]] || [[ "$opt" = *"shiftwidth"* ]]; then
            VALUE="$opt = 4"
        elif [[ "$opt" = *"expandtab"* ]]; then
            VALUE="$opt = true"
        fi
    
        OPTS=( "${OPTS[@]}/$opt" )
    	echo "$VALUE" >> $FILE
    fi
done

# --> Remove backup file
rm -f $FILE_BKP

FILE_ZSHRC="$HOME/.zshrc"
if [[ -f "$FILE_ZSHRC" ]]; then
    echo "# EXPORT ENVS" >> $FILE_ZSHRC
    echo "export PATH=\$HOME/.cargo/bin:\$HOME/.local/bin:\$PATH" >> $FILE_ZSHRC
else
    echo -e "$COLOR_GRAY--> $FILE_ZSHRC, file not found$STYLE_CLEAR"
    exit 1
fi
