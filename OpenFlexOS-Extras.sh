packages=("VirtualBox" "VLC" "FileZilla" "GIMP" "Gparted" "KDE Connect" "qBittorrent" "Audacity" "Brave(AUR)" "AnyDesk(AUR)" "NoMachine(AUR)")
PS3="Please choose an option (1-${#packages[@]}): "
echo "Please Choose a package to install"

select app in "${packages[@]}"; do
    case "$app" in
        "VirtualBox")
        sudo pacman -S --noconfirm virtualbox
            ;;
        "VLC")
                sudo pacman -S --noconfirm vlc
            ;;
        "FileZilla")
                sudo pacman -S --noconfirm filezilla
        clear
            ;;
        "GIMP")
        sudo pacman -S --noconfirm gimp
            ;;
        "Gparted")
        sudo pacman -S --noconfirm gparted
        ;;
        "KDE Connect")
        sudo pacman -S --noconfirm kdeconnect
        ;;
        "qBittorrent")
        sudo pacman -S --noconfirm qbittorrent
        ;;
        "Audacity")
        sudo pacman -S --noconfirm audacity
            ;;
        "Brave(AUR)")
        PKG=brave-bin
        BUILD_USER=_aurbuilder
        BUILD_HOME=/tmp/${BUILD_USER}-home
        BUILD_DIR=/tmp/${PKG}-build


        echo "[+] Installing base tools..."
        sudo pacman -Sy --noconfirm --needed git base-devel

        # Create temporary build user
        if ! id "$BUILD_USER" &>/dev/null; then
            echo "[+] Creating temporary build user ($BUILD_USER)"
            sudo useradd -r -m -d "$BUILD_HOME" -s /bin/bash "$BUILD_USER"
        fi

        # Give that user password-less pacman rights just for building
        # (makepkg uses sudo pacman -S to pull missing deps)
        echo "[+] Temporarily allowing $BUILD_USER to run pacman without password..."
        echo "$BUILD_USER ALL=(ALL) NOPASSWD: /usr/bin/pacman" | sudo tee /etc/sudoers.d/$BUILD_USER > /dev/null
        sudo chmod 440 /etc/sudoers.d/$BUILD_USER

        # Prepare build directory
        sudo rm -rf "$BUILD_DIR"
        sudo mkdir -p "$BUILD_DIR"
        sudo chown -R "$BUILD_USER":"$BUILD_USER" "$BUILD_DIR" "$BUILD_HOME"

        echo "[+] Cloning AUR repo..."
        sudo -u "$BUILD_USER" bash -c "
            cd '$BUILD_DIR'
            git clone https://aur.archlinux.org/${PKG}.git . >/dev/null 2>&1 || true
            git pull --ff-only || true
        "

        echo "[+] Building package..."
        sudo -u "$BUILD_USER" bash -c "
            cd '$BUILD_DIR'
            export HOME='$BUILD_HOME'
            makepkg -s --noconfirm --skippgpcheck
        "

        # Find the built package
        PKGFILE=$(find "$BUILD_DIR" -maxdepth 1 -type f -name "${PKG}-*.pkg.tar.*" | sort -V | tail -n1)
        if [[ -z "$PKGFILE" ]]; then
            echo "[-] Build failed: no package produced."
            sudo rm -f /etc/sudoers.d/$BUILD_USER
            sudo userdel -r "$BUILD_USER" 2>/dev/null || true
            exit 1
        fi

        echo "[+] Installing ${PKGFILE}..."
        sudo pacman -U --noconfirm "$PKGFILE"

        echo "[+] Cleaning up temporary files and user..."
        sudo rm -rf "$BUILD_DIR" "$BUILD_HOME"
        sudo rm -f /etc/sudoers.d/$BUILD_USER
        sudo userdel -r "$BUILD_USER" 2>/dev/null || true

        ;;
        "AnyDesk(AUR)")
            BUILD_USER=_aurbuilder
            BUILD_HOME=/tmp/${BUILD_USER}-home

            # ---- Base tools ----
            sudo pacman -S --noconfirm --needed git base-devel

            # ---- Build user ----
            if ! id "$BUILD_USER" &>/dev/null; then
                sudo useradd -r -m -d "$BUILD_HOME" -s /bin/bash "$BUILD_USER"
            fi

            # ---- Allow pacman ----
            echo "$BUILD_USER ALL=(ALL) NOPASSWD: /usr/bin/pacman" \
              | sudo tee /etc/sudoers.d/$BUILD_USER > /dev/null
            sudo chmod 440 /etc/sudoers.d/$BUILD_USER

            # ---- Function ----
            build_aur_pkg() {
                local PKG="$1"
                local BUILD_DIR="/tmp/${PKG}-build"

                echo "[+] Building AUR package: $PKG"

                sudo rm -rf "$BUILD_DIR"
                sudo mkdir -p "$BUILD_DIR"
                sudo chown -R "$BUILD_USER:$BUILD_USER" "$BUILD_DIR" "$BUILD_HOME"


                sudo -u "$BUILD_USER" bash -c "
                  set -e
                  cd \"$BUILD_DIR\"
                  git clone https://aur.archlinux.org/${PKG}.git .
                  export HOME=\"$BUILD_HOME\"
                  makepkg -s --noconfirm --skippgpcheck
                "

                PKGFILES=$(find "$BUILD_DIR" -maxdepth 1 -name "${PKG}-*.pkg.tar.*")

                if [[ -z "$PKGFILES" ]]; then
                    echo "[-] Failed to build $PKG"
                    exit 1
                fi

                sudo pacman -U --noconfirm $PKGFILES
            }

            # ---- Install order ----
            build_aur_pkg yp-tools
            build_aur_pkg anydesk-bin
        ;;
        "NoMachine()AUR")
            PKG=nomachine
            BUILD_USER=_aurbuilder
            BUILD_HOME=/tmp/${BUILD_USER}-home
            BUILD_DIR=/tmp/${PKG}-build

            echo "[+] Installing base tools..."
            sudo pacman -Sy --noconfirm --needed git base-devel

            # ---- Build user ----
            if ! id "$BUILD_USER" &>/dev/null; then
                echo "[+] Creating temporary build user ($BUILD_USER)"
                sudo useradd -r -m -d "$BUILD_HOME" -s /bin/bash "$BUILD_USER"
            fi

            # ---- Allow pacman ----
            echo "[+] Temporarily allowing $BUILD_USER to run pacman without password..."
            echo "$BUILD_USER ALL=(ALL) NOPASSWD: /usr/bin/pacman" \
              | sudo tee /etc/sudoers.d/$BUILD_USER > /dev/null
            sudo chmod 440 /etc/sudoers.d/$BUILD_USER

            # ---- Build directory ----
            sudo rm -rf "$BUILD_DIR"
            sudo mkdir -p "$BUILD_DIR"
            sudo chown -R "$BUILD_USER:$BUILD_USER" "$BUILD_DIR" "$BUILD_HOME"

            echo "[+] Cloning AUR repo..."
            sudo -u "$BUILD_USER" bash -c "
                set -e
                cd '$BUILD_DIR'
                git clone https://aur.archlinux.org/${PKG}.git .
            "

            echo "[+] Building NoMachine..."
            sudo -u "$BUILD_USER" bash -c "
                set -e
                cd '$BUILD_DIR'
                export HOME='$BUILD_HOME'
                makepkg -s --noconfirm
            "

            PKGFILE=$(find "$BUILD_DIR" -maxdepth 1 -type f -name "${PKG}-*.pkg.tar.*" | sort -V | tail -n1)
            if [[ -z "$PKGFILE" ]]; then
                echo "[-] NoMachine build failed"
                sudo rm -f /etc/sudoers.d/$BUILD_USER
                sudo userdel -r "$BUILD_USER" 2>/dev/null || true
                exit 1
            fi

            echo "[+] Installing NoMachine..."
            sudo pacman -U --noconfirm "$PKGFILE"

            # ---------- Configure NoMachine ----------
            echo "[+] Configuring NoMachine server"
            NXCFG="/usr/NX/etc/server.cfg"

            if ! grep -q '^# Enforced by install script' "$NXCFG"; then
                sudo cp "$NXCFG" "$NXCFG.bak"

                printf '%s\n' \
                  '# Enforced by install script' \
                  'EnableHardwareAcceleration 1' \
                  'PhysicalDisplays 1' \
                  'EnableAutoResume 0' \
                  'DisplayManagerLogin 1' \
                  'CreateDisplay 0' \
                  '' \
                | sudo tee /tmp/nxcfg.prepend > /dev/null

                sudo cat /tmp/nxcfg.prepend "$NXCFG.bak" | sudo tee "$NXCFG" > /dev/null
                sudo rm -f /tmp/nxcfg.prepend
            fi

            # ---------- Qtile session ----------
            echo "[+] Installing Qtile session"
            sudo mkdir -p /usr/share/xsessions
            printf '%s\n' \
              '[Desktop Entry]' \
              'Name=Qtile' \
              'Comment=Qtile Session' \
              'Exec=dbus-run-session qtile start' \
              'Type=Application' \
              'DesktopNames=qtile' \
            | sudo tee /usr/share/xsessions/qtile.desktop > /dev/null

            # ---------- NoMachine launcher ----------
            echo "[+] Installing NoMachine launcher"
            sudo mkdir -p /usr/share/applications
            printf '%s\n' \
              '[Desktop Entry]' \
              'Name=NoMachine' \
              'Comment=Connect to remote desktops' \
              'Exec=/usr/NX/bin/nxplayer' \
              'Icon=NoMachine' \
              'Terminal=false' \
              'Type=Application' \
              'Categories=Network;RemoteAccess;' \
              'StartupNotify=true' \
            | sudo tee /usr/share/applications/nomachine.desktop > /dev/null

            # ---------- systemd service ----------
            echo "[+] Installing nxserver startup service"
            printf '%s\n' \
              '[Unit]' \
              'Description=NoMachine NX Server Startup' \
              'After=network.target' \
              '' \
              '[Service]' \
              'Type=oneshot' \
              'ExecStart=/usr/NX/bin/nxserver --startup' \
              'RemainAfterExit=yes' \
              '' \
              '[Install]' \
              'WantedBy=multi-user.target' \
            | sudo tee /etc/systemd/system/nxserverstartup.service > /dev/null

            sudo systemctl daemon-reload
            sudo systemctl enable --now nxserver.service
            sudo systemctl enable --now nxserverstartup.service

            # ---------- Cleanup ----------
            echo "[+] Cleaning up temporary files and user..."
            sudo rm -rf "$BUILD_DIR" "$BUILD_HOME"
            sudo rm -f /etc/sudoers.d/$BUILD_USER
            sudo userdel -r "$BUILD_USER" 2>/dev/null || true

            echo "✅ NoMachine installation and configuration complete"
        ;;

        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
    REPLY=
    echo ""
    echo ">> Choose another option or exit:"
done
