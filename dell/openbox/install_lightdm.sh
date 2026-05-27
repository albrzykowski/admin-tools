#!/bin/bash

set -e

is_package_installed() {
    local package="$1"
    dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"
}

service_active_and_enabled() {
    local service="$1"
    systemctl is-enabled --quiet "$service" 2>/dev/null
}

install_lightdm() {
    sudo apt install -y --no-install-recommends \
        lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings \
        xserver-xorg dbus-x11 fonts-cantarell \
        gnome-themes-extra

    systemctl enable lightdm
    systemctl set-default graphical.target

    cat > /etc/lightdm/lightdm-gtk-greeter.conf <<EOF
[greeter]
theme-name = Adwaita-dark
icon-theme-name = Adwaita
font-name = Cantarell 11
xft-antialias = true
xft-hintstyle = slight
xft-rgba = rgb
position = 50%,center 50%,center
clock-format = %a %b %-d  %H:%M
indicators = ~host;~spacer;~clock;~spacer;~session;~language;~a11y;~power
EOF

    default_session=$(ls -t /usr/share/xsessions/*.desktop /usr/share/wayland-sessions/*.desktop 2>/dev/null | head -n1 | xargs -r basename -s .desktop)

    mkdir -p /etc/lightdm/lightdm.conf.d

    {
        echo "[Seat:*]"
        [ -n "$default_session" ] && echo "user-session=$default_session"
    } > /etc/lightdm/lightdm.conf.d/50-lightdm.conf
}

install_lightdm
