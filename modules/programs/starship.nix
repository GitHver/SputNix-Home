{ pkgs
, lib
, config
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.programs.starship;
in {

  options = {
    programs.starship.useSubDir = mkEnableOption ''
      the use of a Starship directory in the `.config` directory instead
      of keeping the file directly under the `.config` directory
    '';
  };

  config.home.sessionVariables = mkIf cfg.useSubDir {
    STARSHIP_CONFIG = "${config.home.homeDirectory}/.config/starship/starship.toml";
  };

}
