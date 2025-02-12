{ pkgs
, lib
, config
, ...
}:

let
  inherit (lib) mkOption mkEnableOption mkIf mkBefore;
  inherit (lib.types) str;
  cfg = config.programs.bash;
in {

  options = {
    programs.bash = {
      historyWriteImmediately =
        mkEnableOption
        "the immediate writting of commands to the history file"
      ;
      launchShell = mkOption {
        type = str;
        default = "";
        description =''
          Runs the given shell everytime a Bash instance is launched
        '';
      };
      reSourceEnvVars =
        mkEnableOption
        "the re-sourcing of envvars each time a bash instance is launched"
      ;
      blesh.enable =
        mkEnableOption
        "blesh, a full-featured bash line editor written in pure Bash"
      ;
    };
  };

  config = {
    assertions = [ {
      assertion =
        (lib.asserts.assertOneOf
          "launchShell"
          cfg.launchShell
          [ "" "zsh" "fish" "nushell"]
        );
      message = "Change config.programs.bash.launchShell to a valid value";
    } ];

    programs.bash.bashrcExtra =
      mkIf cfg.reSourceEnvVars "unset __HM_SESS_VARS_SOURCED ; . ~/.profile"
    ;

    programs.bash.initExtra =
      (
      let
        shell = if cfg.launchShell == "nushell" then "nu" else cfg.launchShell;
      in
        if cfg.launchShell == ""
        then ""
        else /*bash*/''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "${shell}" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.${shell}}/bin/${shell} $LOGIN_OPTION
          fi
        ''
      ) + (
        if cfg.historyWriteImmediately then "PROMPT_COMMAND=\"history -a;$PROMPT_COMMAND\"" else ""
      ) + (
        if cfg.blesh.enable then
        (mkBefore ''
          source ${pkgs.blesh}/share/blesh/ble.sh
        '')
        else ""
      )
    ;
  };

}
