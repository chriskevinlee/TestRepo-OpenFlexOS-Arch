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
    clear
    echo "$failedpackage failed to install, retrying..."
    pacman -Syy
    pacman -S --noconfirm --needed "$failedpackage"
  fi
done < <(Package_List)

### Installing Picom
cd /tmp
git clone https://github.com/FT-Labs/picom.git
cd picom
meson setup --buildtype=release build
ninja -C build
ninja -C build install


### Installing nerd-dictation
#echo "Installing python3-pip..."
pacman --noconfirm --needed -S python3 xdotool    
#echo "Cloning nerd-dictation..."
git clone https://github.com/ideasman42/nerd-dictation.git /opt/nerd-dictation
cd /opt/nerd-dictation      
#echo "Creating and activating virtual environment..."
python3 -m venv vosk-venv
source vosk-venv/bin/activate
#echo "Downloading Vosk model..."
wget -q --show-progress https://alphacephei.com/kaldi/models/vosk-model-small-en-us-0.15.zip
#echo "Extracting Vosk model..."
unzip -q vosk-model-small-en-us-0.15.zip
mv vosk-model-small-en-us-0.15 model      
#echo "Installing Vosk inside virtual environment..."
pip install vosk


### install ohmyposh
sudo curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin
