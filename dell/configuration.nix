# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ];

  boot.loader.grub.device = "/dev/sda";
  networking.hostName = "nixos-sway";
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.dbus.enable = true;

  networking.networkmanager.enable = true;

  services.bluetooth.enable = true;

  services.pipewire.enable = true;
  services.pipewire.support32Bit = true;

  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    password = "password";
  };

  services.xserver.enable = false;

  services.sway.enable = true;

  fonts.fonts = with pkgs; [
    dejavu_fonts
    liberation_ttf
  ];

  fonts.fontconfig = ''
    <match target="pattern">
      <test name="family" qual="any">
        <string>Sans</string>
      </test>
      <edit name="size" mode="assign">
        <double>14</double>
      </edit>
    </match>
  '';

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    htop
    alacritty
    firefox
    pcmanfm-qt
    feh
    sxiv
    zathura
    zathura-pdf-mupdf
    pavucontrol
    blueman
    waybar
    rofi
    micro
  ];

  systemd.user.services.waybar = {
    description = "Waybar for Sway";
    after = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.waybar}/bin/waybar";
    install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.blueman-applet = {
    description = "Blueman applet";
    after = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.blueman}/bin/blueman-applet";
    install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.nm-applet = {
    description = "NetworkManager applet";
    after = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.networkmanager}/bin/nm-applet";
    install.WantedBy = [ "default.target" ];
  };

  boot.kernel.sysctl."vm.swappiness" = 10;
  boot.kernel.sysctl."vm.vfs_cache_pressure" = 50;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  programs.qt5.enable = true;
  programs.qt5.fontconfig = true;
}
