declare -a PRINTER_PACKAGES=(
    "cups"
    "cups-client"
    "cups-filters"
    "cups-pdf"
    "printer-driver-all"
    "printer-driver-cups-pdf"
    "system-config-printer"
    "hplip"
    "sane-utils"
    "xsane"
    "simple-scan"
)

declare -a BLUETOOTH_PACKAGES=(
    "bluetooth"
    "bluez"
    "bluez-tools"
    "bluez-cups"
    "blueman"
    "pulseaudio-module-bluetooth"
)

for pkg in "${PRINTER_PACKAGES[@]}"; do
    echo -e "- $pkg"
done

for pkg in "${BLUETOOTH_PACKAGES[@]}"; do
    echo -e "- $pkg"
done

