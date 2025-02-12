{ pkgs, ... }:

{
  imports = [
    ./../../configs/home.nix
    ./../../configs/packages.nix
    ./../../configs/shellSettings.nix
  ];

  home.packages = (with pkgs; [
    ### Rust
    rustc
    cargo
    rust-analyzer
    clippy
    rustfmt
    rustlings
    clang
    ### TOR
    tor-browser
  ]);
}
