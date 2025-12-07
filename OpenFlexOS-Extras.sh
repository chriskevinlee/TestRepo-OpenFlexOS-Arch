packages=("VirtualBox" "VLC" "FileZilla" "GIMP" "Gparted" "KDE Connect" "qBittorrent" "Audacity" "Brave")
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
        "Brave")
		PKG=brave-bin
		BUILD_USER=_aurbuilder
		BUILD_HOME=/tmp/${BUILD_USER}-home
		BUILD_DIR=/tmp/${PKG}-build
		
		
		echo "[+] Installing base tools..."
		pacman -Sy --noconfirm --needed git base-devel
		
		# Create temporary build user
		if ! id "$BUILD_USER" &>/dev/null; then
		    echo "[+] Creating temporary build user ($BUILD_USER)"
		    useradd -r -m -d "$BUILD_HOME" -s /bin/bash "$BUILD_USER"
		fi
		
		# Give that user password-less pacman rights just for building
		# (makepkg uses sudo pacman -S to pull missing deps)
		echo "[+] Temporarily allowing $BUILD_USER to run pacman without password..."
		echo "$BUILD_USER ALL=(ALL) NOPASSWD: /usr/bin/pacman" > /etc/sudoers.d/$BUILD_USER
		chmod 440 /etc/sudoers.d/$BUILD_USER
		
		# Prepare build directory
		rm -rf "$BUILD_DIR"
		mkdir -p "$BUILD_DIR"
		chown -R "$BUILD_USER":"$BUILD_USER" "$BUILD_DIR" "$BUILD_HOME"
		
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
		    rm -f /etc/sudoers.d/$BUILD_USER
		    userdel -r "$BUILD_USER" 2>/dev/null || true
		    exit 1
		fi
		
		echo "[+] Installing ${PKGFILE}..."
		pacman -U --noconfirm "$PKGFILE"
		
		echo "[+] Cleaning up temporary files and user..."
		rm -rf "$BUILD_DIR" "$BUILD_HOME"
		rm -f /etc/sudoers.d/$BUILD_USER
		userdel -r "$BUILD_USER" 2>/dev/null || true
	    ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
    REPLY=
    echo ""
    echo ">> Choose another option or exit:"
done

