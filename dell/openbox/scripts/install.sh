#!/usr/bin/env bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Repo directory: $REPO_DIR"
echo "== Openbox Debian bootstrap =="

source "$REPO_DIR/scripts/packages.sh"

echo ""
echo "Updating package index..."
sudo apt update

echo ""
echo "Installing packages..."
sudo apt install -y "${PACKAGES[@]}"

echo ""
echo "Installing Openbox config..."

OPENBOX_DIR="$HOME/.config/openbox"
mkdir -p "$OPENBOX_DIR"

cp -f "$REPO_DIR/configs/openbox/autostart" "$OPENBOX_DIR/autostart"
cp -f "$REPO_DIR/configs/openbox/rc.xml" "$OPENBOX_DIR/rc.xml"
cp -f "$REPO_DIR/configs/openbox/menu.xml" "$OPENBOX_DIR/menu.xml"

echo ""
echo "Installing tint2 config..."

TINT2_DIR="$HOME/.config/tint2"
mkdir -p "$TINT2_DIR"

cp -f "$REPO_DIR/configs/tint2/tint2rc" "$TINT2_DIR/tint2rc"

echo ""
echo "Installing picom config..."

PICOM_DIR="$HOME/.config/picom"
mkdir -p "$PICOM_DIR"

cp -f "$REPO_DIR/configs/picom/picom.conf" "$PICOM_DIR/picom.conf"

echo ""
echo "Installing rofi config..."

ROFI_DIR="$HOME/.config/rofi"
mkdir -p "$ROFI_DIR"

cp -f "$REPO_DIR/configs/rofi/config.rasi" "$ROFI_DIR/config.rasi"

echo ""
echo "Installing X session config..."

cp -f "$REPO_DIR/configs/xorg/xinitrc" "$HOME/.xinitrc"

echo ""
echo "Installing X resources..."

cp -f "$REPO_DIR/configs/xorg/Xresources" "$HOME/.Xresources"

if command -v xrdb >/dev/null 2>&1; then
  xrdb -merge "$HOME/.Xresources"
fi

XS_DIR="/usr/share/xsessions"

sudo mkdir -p "$XS_DIR"
sudo cp -f "$REPO_DIR/configs/xsessions/openbox.desktop" "$XS_DIR/openbox.desktop"

echo ""
echo "Done."
