# systemctl enable sddm


ln -s /etc/openflexos/usr/share/sddm/themes/corners /usr/share/sddm/themes/corners
#cp -r ./OpenFlexOS-Configs/usr/share/sddm/themes/corners /usr/share/sddm/themes/corners





cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf
sed -i s/Current=/Current=corners/ /etc/sddm.conf
systemctl enable sddm

#cp -r ./OpenFlexOS-Configs/usr/local/bin/* /etc/openflexos/usr/local/bin/
chmod +x /etc/openflexos/usr/local/bin/*




ln -s /etc/openflexos/usr/share/applications/OpenFlexOS_Wallpaper.desktop /usr/share/applications/OpenFlexOS_Wallpaper.desktop
echo "export PATH='/etc/openflexos/usr/local/bin:$PATH'" > /etc/profile.d/custom_paths.sh
#cp ./OpenFlexOS-Configs/usr/share/applications/OpenFlexOS_Wallpaper.desktop /usr/share/applications/OpenFlexOS_Wallpaper.desktop



#cp -r ./OpenFlexOS-Configs/usr/share/themes/* /usr/share/themes/

# This Copies all files and folder in ./OpenFlexOS-Configs/home/user/config to /etc/openflexos/home/users/config/ except what listed as... 
# for exmaple could add... ! -name 'file1.tx' OR ! -name 'directory1'
# 

# find ./OpenFlexOS-Configs/home/user/config -mindepth 1 -maxdepth 1 \
#   ! -name 'openbox' ! -name 'qtile' \
#   -exec cp -r -t /etc/openflexos/home/users/config/ {} +


# # This Copies all files and folder in ./OpenFlexOS-Configs/home/user/ to /etc/openflexos/home/users except what listed as... 
# # for exmaple could add... ! -name 'file1.tx' OR ! -name 'directory1'
# # 
# find ./OpenFlexOS-Configs/home/user/ -mindepth 1 -maxdepth 1 \
#   ! -name 'config' \
#   -exec cp -r -t /etc/openflexos/home/users/ {} +




SWAP_INFO=$(swapon --show --noheadings)
SWAP_DEVICE=$(echo "$SWAP_INFO" | awk '{print $1}')
sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block filesystems keyboard resume fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P
sed -i "s|GRUB_CMDLINE_LINUX=\"\"|GRUB_CMDLINE_LINUX=\"resume=$SWAP_DEVICE\"|" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg





sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
sed -i  's|SHELL=/usr/bin/bash|SHELL=/usr/bin/zsh|' /etc/default/useradd
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
sed -i '/^#ParallelDownloads = 5/a ILoveCandy' /etc/pacman.conf
        


mkdir /usr/share/zsh/plugins/zsh-sudo
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -P /usr/share/zsh/plugins/zsh-sudo
pkgfile -u

echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment
echo "QT_AUTO_SCREEN_SCALE_FACTOR=0" >> /etc/environment
echo "QT_SCALE_FACTOR=1" >> /etc/environment
echo "QT_FONT_DPI=96" >> /etc/environment









#chmod -R +x /etc/skel/.config/$lower_main/scripts/

# cp -r ./OpenFlexOS-Configs/Vivid-Dark-Icons /usr/share/icons/Vivid-Dark-Icons
# cp ./OpenFlexOS-Configs/Generate_gtk_theme.sh /etc/skel/Generate_gtk_theme.sh
# cp ./OpenFlexOS-Configs/Apply_theme.sh /etc/skel/Apply_theme.sh













