#!/bin/bash

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINE0": $BASH_COMMAND"; exit $s' ERR

# Essentials

sudo pacman --noconfirm -S git kitty nitrogen firefox ttf-hack make gcc yajl jsoncpp fakeroot pacman-contrib
mkdir ~/repos
mkdir ~/.scripts
mkdir ~/aur
mkdir ~/.config

git clone https://aur.archlinux.org/material-icons-git.git ~/aur/material-icons-git
cd ~/aur/material-icons-git
makepkg -si
cd

git clone https://aur.archlinux.org/nerd-fonts-jetbrains-mono.git ~/aur/nerd-fonts-jetbrains-mono
cd ~/aur/nerd-fonts-jetbrains-mono
makepkg -si
cd

curl https://raw.githubusercontent.com/miltoneiji/arch-setup/main/scripts/programs -o ~/.scripts/programs
chmod +x ~/.scripts/programs
curl https://raw.githubusercontent.com/miltoneiji/arch-setup/main/scripts/power -o ~/.scripts/power
chmod +x ~/.scripts/power

curl https://raw.githubusercontent.com/miltoneiji/arch-setup/main/vimrc -o ~/.vimrc

# Audio

sudo pacman --noconfirm -S pipewire pipewire-pulse pavucontrol

# Front-end for NetworkManager

sudo pacman --noconfirm -S network-manager-applet

# Display manager

sudo pacman --noconfirm -S xorg-server lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm

# Window manager

# installing dmenu
git clone --branch laptop https://github.com/miltoneiji/dmenu ~/repos/dmenu
cd ~/repos/dmenu
sudo make clean install

# installing polybar
cd
git clone https://aur.archlinux.org/polybar-dwm-module.git ~/aur/polybar-dwm-module
cd ~/aur/polybar-dwm-module
makepkg -si

mkdir ~/.config/polybar
curl https://raw.githubusercontent.com/miltoneiji/arch-setup/main/polybar/launch.sh -o ~/.config/polybar/launch.sh
curl https://raw.githubusercontent.com/miltoneiji/arch-setup/main/polybar/config -o ~/.config/polybar/config
chmod +x ~/.config/polybar/launch.sh

# intalling dwm
cd
git clone --branch laptop https://github.com/miltoneiji/dwm ~/repos/dwm
cd ~/repos/dwm
sudo make clean install

sudo mkdir /usr/share/xsessions
sudo curl https://raw.githubusercontent.com/miltoneiji/arch-setup/main/dwm.desktop /usr/share/xsessions/dwm.desktop

# Git

git config --global user.name "Milton Eiji Takamura"
git config --global user.email "miltontakamura@gmail.com"
