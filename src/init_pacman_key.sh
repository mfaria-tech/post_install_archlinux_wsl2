#!/bin/bash

pacman-key --init
pacman-key --populate
pacman-key -Sy archlinux-keyring
pacman-key -Su
