{ pkgs
, ...
}:

{ config = {

  #====<< User Packages >>=====================================================>
  # If you want install software with non free licenses, set this to true. If
  # you only want one or two programs, try adding them in `modules/unfree.nix`.
  nixpkgs.config.allowUnfree = false;
  # Below is where your user packages are installed.
  # Go to https://search.nixos.org/packages to search for packages & programs.
  home.packages = (with pkgs; [
    #==<< Internet >>==================>
    ### Fiwefwox!
    firefox
    ### Anonymous web browser.
    # tor-browser
    ### FOSS email client.
    # thunderbird
    ### Private messages.
    # signal-desktop
    ### Linux Discord client.
    # vesktop
    ### BitTorrent client.
    # qbittorrent
    ### Tool to download media from the web.
    # yt-dlp
    ### Finds spotify songs and downloads them of YouTube.
    # spotdl
    #==<< Creativity >>================>
    ### FOSS office suite.
    # libreoffice
    ### Markdown file editor.
    # obsidian
    ### GNU image manipulator
    # gimp
    ### Digital illustration program.
    # krita
    ### Video capture software.
    # obs-studio
    ### Exeptional video editing software.
    # kdenlive
    ### Multi track audio editor/recorder.
    # tenacity
    ### 3D modeling software.
    # blender
    #==<< Media >>=====================>
    ### GTK Music player.
    # lollypop
    ### Radio station hub.
    # shortwave
    ### Music streaming client.
    # spotify
    #==<< Misc >>======================>
    ### Windows executable (.exe) compatability layer.
    # wineWowPackages.stable
    ### Open source Minecraft launcher.
    # prismlauncher
    #==<< Programming >>===============>
    ### Rust
    # rustc
    # cargo
    # rust-analyzer
    # clippy
    # rustfmt
    # rustlings
    # clang
    #==<< LSPs >>======================>
    nixd # Nix LSP
    bash-language-server
  ])
  ++ # Nerdfonts
  (with pkgs.nerd-fonts; [
    fira-code
  ]);

};}
