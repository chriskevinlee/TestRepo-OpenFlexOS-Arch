#!/bin/bash
clear

# -------------------------
# Select WM argument
# -------------------------
case "$1" in
    -Q) wm_dir="qtile" ;;
    -O) wm_dir="openbox" ;;
    *)
        echo "Usage: $0 -Q (for Qtile) or -O (for Openbox)"
        sleep 2
        exit 1
        ;;
esac

# -------------------------
# Base config directories
# -------------------------
config_dirs=(
    "$wm_dir"
    "alacritty"
    "dunst"
    "gtk-3.0"
    "gtk-4.0"
    "Kvantum"
    "MyThemes"
    "obmenu-generator"
    "ohmyposh"
    "picom"
    "qt5ct"
    "qt6ct"
    "wallpapers/wallpaper_cave_nature"
    "sxiv/exec"
    "web_bookmarks"
)

# WM-specific directories
if [[ $wm_dir == "openbox" ]]; then
    config_dirs+=(
        "$wm_dir/rofi"
        "$wm_dir/scripts"
        "$wm_dir/sounds"
        "$wm_dir/tint2"
    )
elif [[ $wm_dir == "qtile" ]]; then
    config_dirs+=(
        "$wm_dir/rofi"
        "$wm_dir/scripts"
        "$wm_dir/sounds"
        "$wm_dir/systemd"
    )
fi

# -------------------------
# Prepare /etc/skel with dirs
# -------------------------
mkdir -p /etc/skel/.config
for dir in "${config_dirs[@]}"; do
    mkdir -p "/etc/skel/.config/$dir"
done

# -------------------------
# Populate /etc/skel with symlinks
# -------------------------
if [[ $wm_dir == "openbox" ]]; then
    # Main configs
    for openboxfile in {autostart,menu.xml,snap.sh,environment,rc.xml}; do
        ln -sf /etc/openflexos/home/user/config/openbox/$openboxfile "/etc/skel/.config/openbox/$openboxfile"
    done

    # Scripts
    for openboxscripts in {OpenFlexOS_Applications.sh,OpenFlexOS_BatteryHibernate.sh,OpenFlexOS_Brightness.sh,OpenFlexOS_NerdDictation.sh,OpenFlexOS_Network.sh,OpenFlexOS_Power.sh,OpenFlexOS_Sounds.sh,OpenFlexOS_SSH.sh,OpenFlexOS_UpdateCheck.sh,OpenFlexOS_Volume.sh}; do
        ln -sf /etc/openflexos/usr/local/bin/$openboxscripts "/etc/skel/.config/openbox/scripts/$openboxscripts"
    done

    # Sounds
    for openboxsounds in {ambient-piano-logo-165357.mp3,cozy-weaves-soft-logo-176378.mp3,error-83494.mp3,game-bonus-144751.mp3,introduction-sound-201413.mp3,lovelyboot1-103697.mp3,machine-error-by-prettysleepy-art-12669.mp3,marimba-win-f-2-209688.mp3,retro-audio-logo-94648.mp3}; do
        ln -sf /etc/openflexos/home/user/config/sounds/$openboxsounds "/etc/skel/.config/qtile/sounds/$openboxsounds"
    done


    # Tint2
    for openboxtint2 in tint2rc; do
        ln -sf /etc/openflexos/home/user/config/openbox/tint2/$openboxtint2 "/etc/skel/.config/openbox/tint2/$openboxtint2"
    done

    # Rofi
    for openboxrofi in {config.rasi,Generate_Rofi_theme.sh,theme.rasi}; do
        ln -sf /etc/openflexos/home/user/config/openbox/rofi/$openboxrofi "/etc/skel/.config/openbox/rofi/$openboxrofi"
    done

    # Oh My Posh
    for ohmyposh in base.toml; do
        ln -sf /etc/openflexos/home/user/config/ohmyposh/$ohmyposh "/etc/skel/.config/ohmyposh/$ohmyposh"
    done

    # SXIV Key Handler
    for sxiv in key-handler; do
        ln -sf /etc/openflexos/home/user/config/sxiv/exec/$sxiv "/etc/skel/.config/sxiv/exec/$sxiv"
    done

    # web_bookmarks
    for webbookmarks in sites.txt; do
        ln -sf /etc/openflexos/home/user/config/web_bookmarks/$webbookmarks "/etc/skel/.config/web_bookmarks/$webbookmarks"
    done

    # Dunst
    for dunst in dunstrc; do
        ln -sf /etc/openflexos/home/user/config/dunst/$dunst "/etc/skel/.config/dunst/$dunst"
    done

    # Alacritty
    for alacritty in alacritty.toml; do
        ln -sf /etc/openflexos/home/user/config/alacritty/$alacritty "/etc/skel/.config/alacritty/$alacritty"
    done

    # GTK 3
    for gtk3 in gtk.css; do
        ln -sf /etc/openflexos/home/user/config/gtk-3.0/$gtk3 "/etc/skel/.config/gtk-3.0/$gtk3"
    done

    # GTK 4
    for gtk4 in gtk.css; do
        ln -sf /etc/openflexos/home/user/config/gtk-4.0/$gtk4 "/etc/skel/.config/gtk-4.0/$gtk4"
    done

    # MyThemes
    for mythemes in MyThemes.json; do
        ln -sf /etc/openflexos/home/user/config/MyThemes/$mythemes "/etc/skel/.config/MyThemes/$mythemes"
    done

    # Picom
    for picom in picom.conf; do
        ln -sf /etc/openflexos/home/user/config/picom/$picom "/etc/skel/.config/picom/$picom"
    done

    # Qt5
    for qt5 in qt5.conf; do
        ln -sf /etc/openflexos/home/user/config/qt5ct/$qt5 "/etc/skel/.config/qt5ct/$qt5"
    done

    # Qt6
    for qt6 in qt6.conf; do
        ln -sf /etc/openflexos/home/user/config/qt6ct/$qt6 "/etc/skel/.config/qt6ct/$qt6"
    done

    # Dotfiles
    for userhomedots in {dot.bashrc,dot.gtkrc-2.0,dot.zshrc,dot.xscreensaver}; do
        ln -sf /etc/openflexos/home/user/$userhomedots "/etc/skel/.${userhomedots#dot.}"
    done

    for wallpapers in /etc/openflexos/home/user/config/wallpapers/wallpaper_cave_nature/*; do
        ln -sf "$wallpapers" "/etc/skel/.config/wallpapers/wallpaper_cave_nature/$(basename "$wallpapers")"
    done
fi

if [[ $wm_dir == "qtile" ]]; then


    for qtileconfig in {config.py,OpenFlexOS_AutoStart.sh}; do
        ln -sf /etc/openflexos/home/user/config/qtile/$qtileconfig "/etc/skel/.config/qtile/$qtileconfig"
    done



    # Rofi
    for qtilerofi in {config.rasi,Generate_Rofi_theme.sh,theme.rasi}; do
        ln -sf /etc/openflexos/home/user/config/qtile/rofi/$qtilerofi "/etc/skel/.config/qtile/rofi/$qtilerofi"
    done


    # Scripts
    for qtilescripts in {OpenFlexOS_Applications.sh,OpenFlexOS_BatteryHibernate.sh,OpenFlexOS_Brightness.sh,OpenFlexOS_NerdDictation.sh,OpenFlexOS_Network.sh,OpenFlexOS_Power.sh,OpenFlexOS_Sounds.sh,OpenFlexOS_SSH.sh,OpenFlexOS_UpdateCheck.sh,OpenFlexOS_Volume.sh}; do
        ln -sf /etc/openflexos/usr/local/bin/$qtilescripts "/etc/skel/.config/qtile/scripts/$qtilescripts"
    done



    # Sounds
    for qtilesounds in {ambient-piano-logo-165357.mp3,cozy-weaves-soft-logo-176378.mp3,error-83494.mp3,game-bonus-144751.mp3,introduction-sound-201413.mp3,lovelyboot1-103697.mp3,machine-error-by-prettysleepy-art-12669.mp3,marimba-win-f-2-209688.mp3,retro-audio-logo-94648.mp3}; do
        ln -sf /etc/openflexos/home/user/config/sounds/$qtilesounds "/etc/skel/.config/qtile/sounds/$qtilesounds"
    done


    # Oh My Posh
    for ohmyposh in base.toml; do
        ln -sf /etc/openflexos/home/user/config/ohmyposh/$ohmyposh "/etc/skel/.config/ohmyposh/$ohmyposh"
    done

    # SXIV Key Handler
    for sxiv in key-handler; do
        ln -sf /etc/openflexos/home/user/config/sxiv/exec/$sxiv "/etc/skel/.config/sxiv/exec/$sxiv"
    done

    # web_bookmarks
    for webbookmarks in sites.txt; do
        ln -sf /etc/openflexos/home/user/config/web_bookmarks/$webbookmarks "/etc/skel/.config/web_bookmarks/$webbookmarks"
    done

    # Dunst
    for dunst in dunstrc; do
        ln -sf /etc/openflexos/home/user/config/dunst/$dunst "/etc/skel/.config/dunst/$dunst"
    done

    # Alacritty
    for alacritty in alacritty.toml; do
        ln -sf /etc/openflexos/home/user/config/alacritty/$alacritty "/etc/skel/.config/alacritty/$alacritty"
    done

    # GTK 3
    for gtk3 in gtk.css; do
        ln -sf /etc/openflexos/home/user/config/gtk-3.0/$gtk3 "/etc/skel/.config/gtk-3.0/$gtk3"
    done

    # GTK 4
    for gtk4 in gtk.css; do
        ln -sf /etc/openflexos/home/user/config/gtk-4.0/$gtk4 "/etc/skel/.config/gtk-4.0/$gtk4"
    done

    # MyThemes
    for mythemes in MyThemes.json; do
        ln -sf /etc/openflexos/home/user/config/MyThemes/$mythemes "/etc/skel/.config/MyThemes/$mythemes"
    done

    # Picom
    for picom in picom.conf; do
        ln -sf /etc/openflexos/home/user/config/picom/$picom "/etc/skel/.config/picom/$picom"
    done

    # Qt5
    for qt5 in qt5.conf; do
        ln -sf /etc/openflexos/home/user/config/qt5ct/$qt5 "/etc/skel/.config/qt5ct/$qt5"
    done

    # Qt6
    for qt6 in qt6.conf; do
        ln -sf /etc/openflexos/home/user/config/qt6ct/$qt6 "/etc/skel/.config/qt6ct/$qt6"
    done

    # Dotfiles
    for userhomedots in {dot.bashrc,dot.gtkrc-2.0,dot.zshrc,dot.xscreensaver}; do
        ln -sf /etc/openflexos/home/user/$userhomedots "/etc/skel/.${userhomedots#dot.}"
    done

    for wallpapers in /etc/openflexos/home/user/config/wallpapers/wallpaper_cave_nature/*; do
        ln -sf "$wallpapers" "/etc/skel/.config/wallpapers/wallpaper_cave_nature/$(basename "$wallpapers")"
    done

fi

echo ">> /etc/skel prepared with symlinks for $wm_dir"


# -------------------------
# Main loop
# -------------------------
while true; do
    # Get real users (UID >= 1000 and not nobody)
    all_users=($(awk -F: '($3 >= 1000) && ($1 != "nobody") { print $1 }' /etc/passwd))

    # Filter users missing this WM config
    missing_users=()
    for user in "${all_users[@]}"; do
        if [ ! -d "/home/$user/.config/$wm_dir" ]; then
            missing_users+=("$user")
        fi
    done

    clear
    echo "Select a user to set up $wm_dir from /etc/skel:"
    index=1
    for user in "${missing_users[@]}"; do
        echo "$index) $user"
        ((index++))
    done
    echo "$index) Create a new user"
    ((index++))
    echo "$index) Return to main menu"

    read -p "Choose an option: " choice

    if [[ "$choice" -ge 1 && "$choice" -le "${#missing_users[@]}" ]]; then
        selected_user="${missing_users[$((choice-1))]}"
        user_home="/home/$selected_user"

        echo ">> Copying from /etc/skel to $selected_user..."
        cp -a /etc/skel/. "$user_home/"
        chown -R "$selected_user:$selected_user" "$user_home"

    elif [[ "$choice" -eq $((${#missing_users[@]}+1)) ]]; then
        read -p "Enter new username: " newuser
        if id "$newuser" &>/dev/null; then
            echo "User '$newuser' already exists."
            sleep 2
            continue
        else
            useradd -m "$newuser"
            passwd "$newuser"
            read -p "Add '$newuser' to sudo group? (y/n): " yn
            [[ "$yn" =~ ^[Yy]$ ]] && usermod -aG wheel "$newuser"
            echo ">> New user '$newuser' created with configs from /etc/skel"
        fi

    elif [[ "$choice" -eq $((${#missing_users[@]}+2)) ]]; then
        echo "Returning to main menu..."
        sleep 1
        exit 0
    else
        echo "Invalid selection."
        sleep 2
    fi
done
