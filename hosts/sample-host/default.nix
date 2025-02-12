{ pkgs, ... }:

{
  imports = [
    ./../../configs/home.nix
    ./../../configs/packages.nix
    ./../../configs/shellSettings.nix
  ];

  home.packages = (with pkgs; [
    # Here you can put any package you would put in `/configs/packages` and ir
    # will only appear on this host. For example:
    # obs-studio
    # prismlauncher
    # etc...
  ]);
}
