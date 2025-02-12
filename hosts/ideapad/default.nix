{ pkgs, ... }:

{
  imports = [
    ./../../configs/home.nix
    ./../../configs/packages.nix
    ./../../configs/shellSettings.nix
  ];

  home.packages = (with pkgs; [
    # Packages
  ]);
}
