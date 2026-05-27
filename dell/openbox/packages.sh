# Package groups for better organization
PACKAGES_CORE=(
    xorg xorg-dev xbacklight xbindkeys xvkbd xinput
    build-essential openbox tint2 xdotool dbus-x11
    libnotify-bin libnotify-dev
)

PACKAGES_UI=(
    polybar dunst feh nwg-look xsettingsd network-manager-gnome lxpolkit
)

PACKAGES_FILE_MANAGER=(
    thunar thunar-archive-plugin thunar-volman
    gvfs-backends dialog mtools smbclient cifs-utils fd-find unzip
)

PACKAGES_AUDIO=(
    pavucontrol pulsemixer pamixer pipewire-audio
)

PACKAGES_UTILITIES=(
    avahi-daemon acpi acpid xfce4-power-manager xfce4-appfinder
    flameshot qimgv xdg-user-dirs-gtk
)

PACKAGES_TERMINAL=(
    # exa/eza handled separately due to debian/ubuntu differences
)

PACKAGES_FONTS=(
    fonts-recommended fonts-font-awesome fonts-terminus
)

PACKAGES_BUILD=(
    cmake meson ninja-build curl pkg-config wget
)

# Install packages by group
if [ "$ONLY_CONFIG" = false ]; then
    msg "Installing core packages..."
    sudo apt-get install -y "${PACKAGES_CORE[@]}" || die "Failed to install core packages"

    msg "Installing UI components..."
    sudo apt-get install -y "${PACKAGES_UI[@]}" || die "Failed to install UI packages"

    msg "Installing file manager..."
    sudo apt-get install -y "${PACKAGES_FILE_MANAGER[@]}" || die "Failed to install file manager"

    msg "Installing audio support..."
    sudo apt-get install -y "${PACKAGES_AUDIO[@]}" || die "Failed to install audio packages"

    msg "Installing system utilities..."
    sudo apt-get install -y "${PACKAGES_UTILITIES[@]}" || die "Failed to install utilities"
    
    # Try firefox-esr first (Debian), then firefox (Ubuntu)
    sudo apt-get install -y firefox-esr 2>/dev/null || sudo apt-get install -y firefox 2>/dev/null || msg "Note: firefox not available, skipping..."
    
    # Try exa first (Debian 12), then eza (newer Ubuntu)
    sudo apt-get install -y exa 2>/dev/null || sudo apt-get install -y eza 2>/dev/null || msg "Note: exa/eza not available, skipping..."

    msg "Installing fonts..."
    sudo apt-get install -y "${PACKAGES_FONTS[@]}" || die "Failed to install fonts"

    msg "Installing build dependencies..."
    sudo apt-get install -y "${PACKAGES_BUILD[@]}" || die "Failed to install build tools"

    # Install obmenu-generator dependencies
    msg "Installing obmenu-generator dependencies..."
    sudo apt-get install -y libgtk3-perl libmodule-build-perl libdata-dump-perl \
        libfile-desktopentry-perl cpanminus make

    # Enable services
    sudo systemctl enable avahi-daemon acpid
else
    msg "Skipping package installation (--only-config mode)"
fi

