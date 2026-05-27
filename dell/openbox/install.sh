SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/openbox"
TEMP_DIR="/tmp/openbox_$$"

sudo apt-get update && sudo apt-get upgrade -y

sudo apt install -y "${PACKAGES_CORE[@]}"
sudo apt install -y "${PACKAGES_UI[@]}"
sudo apt install -y "${PACKAGES_FILE_MANAGER[@]}"
sudo apt install -y "${PACKAGES_AUDIO[@]}"
sudo apt install -y "${PACKAGES_UTILITIES[@]}"
sudo apt install -y firefox-esr 2>/dev/null || sudo apt install -y firefox 2>/dev/null
sudo apt install -y exa 2>/dev/null || sudo apt install -y eza 2>/dev/null
sudo apt install -y "${PACKAGES_FONTS[@]}"
sudo apt install -y "${PACKAGES_BUILD[@]}"
sudo apt install -y libgtk3-perl libmodule-build-perl libdata-dump-perl libfile-desktopentry-perl cpanminus make

sudo systemctl enable avahi-daemon acpid

xdg-user-dirs-update

rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"

cp -a "$SCRIPT_DIR/config/." "$CONFIG_DIR/"

# Theme
mkdir -p ~/.themes
cp -r "$SCRIPT_DIR/config/themes/Simply_Circles_Dark" ~/.themes/

# nwg-look
desktop_file="$HOME/.local/share/applications/nwg-look.desktop"
mkdir -p "$(dirname "$desktop_file")"

cat > "$desktop_file" <<EOF
[Desktop Entry]
Name=Appearance
Comment=Customize the look of your desktop
Exec=nwg-look
Icon=preferences-desktop-theme
Terminal=false
Type=Application
Categories=Settings;GTK;X-XFCE;
EOF

chmod +x "$desktop_file"

# Other packages 
sudo apt install -y picom

sudo apt install -y rofi

bash ./install_theme.sh

bash ./install_lightdm.sh

bash ./install_additional_packages.sh


