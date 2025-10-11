#!/bin/bash





echo "[openflexos]" >> /etc/pacman.conf
echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf
echo "Server = https://chriskevinlee.github.io/TestRepo-OpenFlexOS-Packages/" >> /etc/pacman.conf

pacman -Sy

# ## This script setup any prerequisites before install starts

# # create openflexos directory for all config files to be stored as config files will be sym linked
# mkdir /etc/openflexos
# mkdir -p /etc/openflexos/home/users/config/obmenu-generator/
# mkdir -p /etc/openflexos/home/users/config/wallpapers/wallpaper_cave_nature/
# mkdir -p /etc/openflexos/usr/local/bin


# ######## git clone https://github.com/chriskevinlee/wallpaper_cave_nature.git /etc/openflexos/home/users/config/wallpapers/wallpaper_cave_nature/

# # downloads config files to root of install script. NEED TO ADD SOMETHING TO THE END TO MAKE THIS WORK
# git clone https://github.com/chriskevinlee/OpenFlexOS-Configs 
# clear

# # Check to make sure OpenFlexOS-Configs is aviable 
# if [[ ! -d OpenFlexOS-Configs ]]; then
#     echo "OpenFlexOS-Configs directory does not exist, Make sure you have OpenFlexOS-Configs in the root of the script $0"
#     echo "See https://github.com/chriskevinlee/OpenFlexOS-Configs"
#     exit 0
# fi
