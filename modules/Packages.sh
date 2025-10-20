#!/bin/bash

Package_List() {
  cat <<EOF
openflexos-configs
openflexos-dmenu
sddm
mpv
xscreensaver
feh
rofi
arandr
ttf-nerd-fonts-symbols
xdg-user-dirs
alacritty
lsd
bat
pavucontrol-qt
pipewire-pulse
git
qt5-graphicaleffects
qt5-quickcontrols2
qt5-svg
qt6-multimedia
qt6-5compat
zsh
zsh-history-substring-search
zsh-syntax-highlighting
zsh-autosuggestions
wget
jq
firefox
flameshot
htop
caja
xarchiver
p7zip
unzip
polkit-gnome
sxiv
qt5ct
qt6ct
kvantum-qt5
lxappearance-gtk3
materia-gtk-theme
dunst
picom
wmctrl
xf86-input-libinput
xbindkeys
sxhkd
playerctl
deepin-calculator
zenity
python-psutil
pacman-contrib
pkgfile
gcc
pkg-config
python
meson
ninja
xcb-util
libx11
pixman
libdbus
libconfig
libepoxy
libev
uthash
base-devel
gvim
EOF
}


# Install all
while read -r package; do
  sudo pacman -S --noconfirm --needed "$package"
done < <(Package_List)

# Recheck any failed installs
while read -r failedpackage; do
  if ! pacman -Q "$failedpackage" &>/dev/null; then
    echo "$failedpackage failed to install, retrying..."
    sudo pacman -S --noconfirm --needed "$failedpackage"
  fi
done < <(Package_List)
