{ pkgs
, lib
, config
, inputs
, alib
, pAtt
, ...
}:

let
  inherit (alib.enabling) enabled disabled;
  inherit (lib) mkDefault;
  inherit (pAtt) username;
in { config = {

  #====<< Home manager settings >>=============================================>
  # for more home-manager options, go to:
  # https://home-manager-options.extranix.com/
  programs.home-manager = enabled;
  home = {
    username = username;
    homeDirectory = mkDefault ("/home/" + username);
    sessionPath = let home = config.home.homeDirectory; in [
      # Paths to add to your $PATH variable.
      "${home}/.local/bin"
      # "${home}/.cargo/bin"
    ];
    stateVersion = mkDefault "25.05";
  };

  #====<< Nix specific settings >>=============================================>
  nix = {
    ### Below may contain inaccurate infirmation on how the system selects
    ### what version of Nix to use
    # You can use a different version of Nix than the System defined one.
    # By default this is `pkgs.nix` (CppNix). Lix is a fork of CppNix and has
    # in recent times shown to be a more stable implementation of Nix.
    package = pkgs.nix;
    # For `nixd` package and option evaluation
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "home-manager=${inputs.home-manager}"
    ];
    # Since the regular `nix.gc` in NixOS doesn't collect user profiles, all
    # user packages are left on the system. This sets it so that your user
    # wipes GCs your roots daily, as you will most likely never rollback a
    # home-manager generation but instead just build a new one.
    gc = {
      automatic = true;
      frequency = "daily";
      options   = "--delete-older-than 1d";
    };
  };

  #====<< Themes & fonts >>====================================================>
  # This allows fontconfig to detect font packages, but it does not set the as
  # your preffered font. You'll need to open [system/app] settings and apply
  # them yourself.
  fonts.fontconfig = enabled;
  home.pointerCursor = {
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
    size = 30;
  };
  # Makes GTK apps use the system cursor.
  gtk.cursorTheme = config.home.pointerCursor;

  #====<< Symlinking >>========================================================>
  home.mutableFile = {
    ".config" = {
      source = ./../assets/dot-config;
    };
    ".local/bin" = {
      source = ./../assets/scripts.sh;
    };
    # "mkfile" = {
    #   source = ./../assets/singularFiles/mkfile;
    # };
  };

};}
