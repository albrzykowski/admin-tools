# Openbox Debian Bootstrap

Projekt do szybkiej konfiguracji środowiska graficznego Openbox na systemie Debian/APT. Automatyzuje instalację pakietów oraz rozmieszcza gotowe pliki konfiguracyjne.

## Struktura projektu

```
openbox/
├── README.md
├── configs/
│   ├── openbox/
│   │   ├── autostart
│   │   ├── menu.xml
│   │   └── rc.xml
│   ├── picom/
│   │   └── picom.conf
│   ├── rofi/
│   │   └── config.rasi
│   ├── tint2/
│   │   └── tint2rc
│   └── xorg/
│       └── xinitrc
├── profiles/
│   ├── base.sh
│   └── laptop.sh
└── scripts/
    ├── install.sh
    └── packages.sh
```

## Zawartość plików

### `scripts/install.sh`

Główny skrypt instalacyjny. Aktualizuje indeks pakietów, instaluje wszystkie pakiety z listy, a następnie kopiuje pliki konfiguracyjne do odpowiednich katalogów w `~/.config/`.

```bash
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
echo "Installing Openbox config (copy mode)..."

OPENBOX_DIR="$HOME/.config/openbox"
mkdir -p "$OPENBOX_DIR"

cp -f "$REPO_DIR/configs/openbox/autostart" "$OPENBOX_DIR/autostart"
cp -f "$REPO_DIR/configs/openbox/rc.xml" "$OPENBOX_DIR/rc.xml"

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

XORG_DIR="$HOME"
cp -f "$REPO_DIR/configs/xorg/xinitrc" "$XORG_DIR/.xinitrc"

echo "X session config installed."

echo ""
echo "Done."
```

### `scripts/packages.sh`

Definiuje bazową tablicę pakietów do zainstalowania, a następnie ładuje profile.

```bash
#!/usr/bin/env bash

# Base system packages (always installed)

PACKAGES=(
  xorg-server
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
)

# Load profiles
source "$REPO_DIR/profiles/base.sh"
source "$REPO_DIR/profiles/laptop.sh"
```

### `profiles/base.sh`

Dodaje podstawowe narzędzia CLI do listy pakietów.

```bash
# Common tools

PACKAGES+=(
  git
  curl
  wget
  htop
  neofetch
)
```

### `profiles/laptop.sh`

Dodaje narzędzia do zarządzania energią na laptopie.

```bash
# Laptop power tools

PACKAGES+=(
  tlp
  tlp-rdw
  acpi
  powertop
  brightnessctl
)
```

### `configs/openbox/autostart`

Uruchamia usługi i programy po starcie sesji Openbox.

```bash
# Background
nitrogen --restore &

# Compositor
picom --config ~/.config/picom/picom.conf &

# Panel
tint2 &

# Network
nm-applet &

# Volume
volumeicon &

# PolicyKit
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# Desktop icons
pcmanfm --desktop &
```

### `configs/openbox/menu.xml`

Plik menu prawego przycisku myszy Openbox – obecnie pusty (wymaga uzupełnienia).

```xml
(pusty)
```

### `configs/openbox/rc.xml`

Główna konfiguracja menedżera okien Openbox.

```xml
<?xml version="1.0" encoding="UTF-8"?>

<openbox_config xmlns="http://openbox.org/3.4/rc">

  <resistance>
    <strength>10</strength>
    <screen_edge_strength>20</screen_edge_strength>
  </resistance>

  <focus>
    <focusNew>yes</focusNew>
    <followMouse>no</followMouse>
    <raiseOnFocus>yes</raiseOnFocus>
  </focus>

  <placement>
    <policy>Smart</policy>
  </placement>

  <theme>
    <name>Clearlooks</name>
  </theme>

  <keyboard>

    <!-- Terminal -->
    <keybind key="W-Return">
      <action name="Execute">
        <command>lxterminal</command>
      </action>
    </keybind>

    <!-- App launcher -->
    <keybind key="W-space">
      <action name="Execute">
        <command>rofi -show drun</command>
      </action>
    </keybind>

    <!-- Reload Openbox -->
    <keybind key="W-S-r">
      <action name="Reconfigure"/>
    </keybind>

    <!-- Close window -->
    <keybind key="W-q">
      <action name="Close"/>
    </keybind>

  </keyboard>

</openbox_config>
```

### `configs/picom/picom.conf`

Konfiguracja kompozytora Picom (backend Xrender, cienie, fade).

```conf
# Picom compositor config (minimal stable)

backend = "xrender";

vsync = true;

shadow = true;
shadow-radius = 12;
shadow-offset-x = -5;
shadow-offset-y = -5;
shadow-opacity = 0.4;

fading = true;
fade-in-step = 0.03;
fade-out-step = 0.03;

inactive-opacity = 0.95;
active-opacity = 1.0;

frame-opacity = 1.0;

shadow-exclude = [
  "name = 'Notification'",
  "class_g = 'Conky'",
  "class_g = 'Dunst'"
];
```

### `configs/rofi/config.rasi`

Konfiguracja launchera aplikacji Rofi.

```rasi
configuration {
  modi: "drun,run,window";
  show-icons: true;
  drun-display-format: "{name}";
  font: "Sans 11";
  terminal: "lxterminal";
}

window {
  transparency: "real";
  background-color: #1e1e1e;
  border: 0;
  width: 40%;
}

listview {
  lines: 8;
  spacing: 4;
}

element {
  padding: 8px;
  border-radius: 4px;
}

element selected {
  background-color: #3a3a3a;
}
```

### `configs/tint2/tint2rc`

Konfiguracja panelu Tint2 (pasek zadań, zasobnik systemowy, zegar).

```conf
# Tint2 panel config (minimal usable setup)

panel_items = TSC
panel_size = 100% 30
panel_margin = 0 0
panel_padding = 6 3 6
panel_background_id = 1

font_shadow = 0
panel_background_id = 1

# Taskbar
taskbar_mode = multi_desktop
taskbar_padding = 2 2 2
taskbar_background_id = 0

# Clock
time1_format = %H:%M
time1_font = Sans 10
clock_font_color = #ffffff 100

# System tray
systray_padding = 4 4 4
systray_background_id = 0

# Mouse actions
mouse_left = toggle
mouse_right = close
```

### `configs/xorg/xinitrc`

Skrypt startowy sesji X – ładuje zasoby, uruchamia menedżera sieci i włącza Openbox.

```bash
#!/usr/bin/env bash

# Load resources
xrdb -merge ~/.Xresources 2>/dev/null

# Start network (if not running via systemd)
nm-applet &

# Start Openbox session
exec openbox-session
```

## Użycie

Aby zainstalować środowisko, uruchom:

```bash
./scripts/install.sh
```

Skrypt wykona `sudo apt update && sudo apt install` dla wszystkich pakietów, a następnie skopiuje pliki konfiguracyjne do `~/.config/`.

## Dostosowywanie

- Aby dodać własne pakiety, edytuj `scripts/packages.sh` lub utwórz nowy profil w katalogu `profiles/`.
- Pliki konfiguracyjne w `configs/` można modyfikować przed uruchomieniem instalacji.
- Profile ładują się sekwencyjnie – można je wyłączyć, usuwając linie `source` w `packages.sh`.

## Co dalej

autostart cleanup + stabilność desktopu

czyli:

upewniamy się, że wszystko startuje poprawnie
dodajemy retry / safety (np. nm-applet, polkit)
porządkujemy kolejność startu
