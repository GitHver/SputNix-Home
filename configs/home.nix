{ pkgs
, lib
, config
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

  #====<< Nix settings >>====================================================>
  # Since the regular `nix.gc` doesn't collect user profiles, all user
  # packages are left on the system (like running `sudo nix-collect-garbage`).
  # This sets it to also (your) user profiles.
  nix.gc = {
    automatic = true;
    frequency = "daily";
    options   = "--delete-older-than 1d";
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

  #====<< Symlinking >>========================================================>
  home.mutableFile = {
    ".config" = {
      source = ./../assets/dot-config;
    };
    ".local/bin" = {
      source = ./../assets/scripts.sh;
    };
    ".mozilla/firefox/${config.home.username}" = {
      source = ./../assets/firefox;
    };
    # "single-file" = {
    #   source = ./../assets/singularFiles/file;
    # };
  };

};}
