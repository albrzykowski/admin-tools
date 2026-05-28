#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
  exit 1
fi

USER_NAME=$(logname)

apt update >/dev/null 2>&1
apt upgrade -y >/dev/null 2>&1

apt install -y >/dev/null 2>&1 \
  sudo curl wget git htop nano unzip gnupg ca-certificates \
  net-tools iproute2 dnsutils network-manager \
  xdg-utils file-roller

apt install -y --no-install-recommends >/dev/null 2>&1 \
  gnome-shell \
  gnome-session \
  gdm3 \
  nautilus \
  gnome-control-center \
  gnome-terminal

apt install -y >/dev/null 2>&1 \
  dbus-user-session \
  gnome-keyring \
  xdg-user-dirs \
  gsettings-desktop-schemas \
  gnome-tweaks \
  gnome-shell-extensions

apt install -y >/dev/null 2>&1 \
  pipewire \
  pipewire-pulse

systemctl enable gdm3 >/dev/null 2>&1
systemctl enable NetworkManager >/dev/null 2>&1

sudo -u "$USER_NAME" xdg-user-dirs-update >/dev/null 2>&1

sudo -u "$USER_NAME" mkdir -p /home/$USER_NAME/Templates >/dev/null 2>&1
sudo -u "$USER_NAME" touch /home/$USER_NAME/Templates/Empty\ Document >/dev/null 2>&1

sudo -u "$USER_NAME" dbus-run-session bash << 'EOF'

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.interface clock-show-seconds true

gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.mutter center-new-windows true

EOF

sudo -u "$USER_NAME" gnome-extensions enable dash-to-dock@micxgx.gmail.com >/dev/null 2>&1 || true

sudo -u "$USER_NAME" dbus-run-session bash << 'EOF'

gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.8
gsettings set org.gnome.shell.extensions.dash-to-dock always-center-icons true

EOF

apt autoremove -y >/dev/null 2>&1

read -p "Reboot now? (y/n): " r >/dev/tty
if [[ "$r" =~ ^[Yy]$ ]]; then
  reboot
fi
