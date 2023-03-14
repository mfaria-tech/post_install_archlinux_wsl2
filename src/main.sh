#!/bin/bash

# Set global variables
COLOR_BLUE="\e[0;34m"
COLOR_GRAY="\e[1;30m"
COLOR_GREEN="\e[0;32m"
COLOR_RED="\e[0;31m"
STYLE_CLEAR="\e[0m"

CURUSER=$(whoami)

PKGS_BASE_DEVEL=(
    base-devel
    git
    clang
    curl
    wget
    zsh
    openssh
)

PKGS_DEV=(
    rust
    yarn
    npm
    python
    lua
    neovim
)

PKG_POWERLEVEL="zsh-theme-powerlevel10k-git"

FONTS=(
    ttf-meslo-nerd-font-powerlevel10k
    powerline-fonts
    awesome-terminal-fonts
    ttf-fira-code
)

update_sudoers()
{
    file_update_sudoers="update_sudoers.sh"
    if [[ -f "$file_update_sudoers" ]]; then
        echo -e "\n$COLOR_GRAY--> Setting setup sudoers file$STYLE_CLEAR"
        sudo "./$file_update_sudoers"
    else
        echo -e "\n$COLOR_GRAY--> $file_update_sudoers, file not found$STYLE_CLEAR"
        exit 1
    fi
}

set_parallel_downloads()
{
    file_set_parallel_downloads="set_parallel_downloads.sh"
    if [[ -f "$file_set_parallel_downloads" ]]; then
        echo -e "\n$COLOR_GRAY--> Setting pacman conf file$STYLE_CLEAR"
        sudo "./$file_set_parallel_downloads"
    else
        echo -e "\n$COLOR_GRAY--> $file_set_parallel_downloads, file not found$STYLE_CLEAR"
        exit 1
    fi
}

init_pacman_key()
{
    file_key_sign="init_pacman_key.sh"
    if [[ -f "$file_key_sign" ]]; then
        echo -e "\n$COLOR_GRAY--> Initialize pacman key$STYLE_CLEAR"
        sudo "./$file_key_sign"
    else
        echo -e "\n$COLOR_GRAY--> $file_key_sign, file not found$STYLE_CLEAR"
        exit 1
    fi
}

configure_lvim()
{
    file_configure_lvim="configure_lvim.sh"
    if [[ -f "$file_configure_lvim" ]]; then
        echo -e "$COLOR_GRAY--> Configure lunar vim$STYLE_CLEAR"
        "./$file_configure_lvim"
    else
        echo -e "$COLOR_GRAY--> $file_configure_lvim, file not found$STYLE_CLEAR"
        exit 1
    fi
}

# Main instructions
if [[ $UID -eq 0 ]]; then # check if is root
    echo -e "$COLOR_BLUE>> Set root password$STYLE_CLEAR"
    passwd

    update_sudoers

    set_parallel_downloads

    echo -e "\n$COLOR_BLUE>> Add default user$STYLE_CLEAR"
    read -p "USER: " newuser
    useradd -m -G wheel -s /bin/bash $newuser

    init_pacman_key
else
    sudo pacman -Syyu

    # --> Install base devel, and other base packages
    echo -e "$COLOR_GREEN--> Install base packages$STYLE_CLEAR"
    for curpkg in ${PKGS_BASE_DEVEL[@]}; do
        sudo pacman -S --noconfirm --needed "$curpkg"
    done

    # --> Install programing language packages
    echo -e "$COLOR_GREEN--> Install dev packages$STYLE_CLEAR"
    for curpkg in ${PKGS_DEV[@]}; do
        sudo pacman -S --noconfirm --needed "$curpkg"
    done

    # --> Install Lunar vim
    LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)

    # --> Update file, configure Lunar vim
    configure_lvim

    # --> Install YAY, AUR helper
    echo -e "$COLOR_GREEN--> Install YAY$STYLE_CLEAR"
    cd /tmp/
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si

    # --> Install theme to zsh shell
    # --> script post-finalization, configure Theme: Use p10k configure
    echo -e "$COLOR_GREEN--> Install Powerlevel10k theme$STYLE_CLEAR"
    yay -S --noconfirm "$PKG_POWERLEVEL"
    for font in ${FONTS[@]}; do
        yay -S --noconfirm "$font"
    done

    # --> Set zsh how default shell
    chsh -s /usr/bin/zsh
fi
