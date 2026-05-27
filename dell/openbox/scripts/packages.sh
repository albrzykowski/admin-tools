#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

PACKAGES=(
  xorg
  openbox
  obconf
  obmenu
  lightdm
  lightdm-gtk-greeter
  tint2
  picom
  rofi
  pcmanfm
  lxappearance
  nitrogen
  feh
  network-manager
  network-manager-gnome
  pulseaudio
  pavucontrol
  volumeicon-alsa
  lxterminal
  policykit-1-gnome
  fonts-dejavu
  xsettingsd
)

PROFILE_DIR="$REPO_DIR/profiles"

if [[ -f "$PROFILE_DIR/base.sh" ]]; then
  source "$PROFILE_DIR/base.sh"
fi

if [[ -f "$PROFILE_DIR/laptop.sh" ]]; then
  source "$PROFILE_DIR/laptop.sh"
fi

PACKAGES=($(printf "%s\n" "${PACKAGES[@]}" | awk '!seen[$0]++'))
