{ pkgs
, config
, alib
, pAtt
, ...
}:

let
  inherit (alib.enabling) enabled disabled enableAllShells;
  inherit (pAtt) gitUsername gitEmail gitMbranch parentRepo homeManagerRepo nixosRepo;
in { config = {

  #====<< Shared shell settings >>=============================================>
  home.sessionVariables = {
    NIXOS_REPO = config.home.homeDirectory + parentRepo + nixosRepo;
    HOMEMANAGER_REPO = config.home.homeDirectory + parentRepo + homeManagerRepo;
    GITMBRANCH = gitMbranch;
    # ANY_VARIBLE = "ANY-VALUE";
  };
  home.shellAliases = {
    #==<< Nix misc aliases >>==>
    no = "cd ~${parentRepo + nixosRepo}";
    hm = "cd ~${parentRepo + homeManagerRepo}";
    #==<< Git aliases >>=======>
    lg = "lazygit";
  };

  #====<< Main shell settings >>===============================================>
  # Bash - The Bourne Again Shell. The default shell for most Linux Distros.
  programs.bash = enabled // {
    # Write commands to the history file immediatly.
    historyWriteImmediately = true;
    # Erase duplicates in the history file and make commands beginning with
    # whitespace not be written to the history file.
    historyControl = [ "erasedups" "ignorespace" ];
    # Commands that don't go into the history file.
    historyIgnore = [
      "ls" "ll" "l" "cd" "yy"
      "exit" "zsh" "fish" "nu"
    ] # Make all aliases get ignored in history.
    ++ (builtins.attrNames config.home.shellAliases);
    # Makes sure that when you open a new shell the envvars get sourced.
    reSourceEnvVars = true;
    # BLE.sh - A pure *B*ash *L*ine *E*ditor (.sh). Gives Bash similar features
    # to base Fish and ZSH plugins. Try enabling it and you might find you don't
    # need any other shell than Bash. Can be slow on older hardware.
    blesh = disabled;
    # NOTE: `launchShell` is used as BASH is the default shell as defined in the
    # NixOS config repository. So instead of changing the system files to set a
    # login shell for each user, we can instead just launch our preferred shell
    # every time an interactive Bash shell is initialized. This way you can have
    # Bash as your login shell and `bin/sh` and use (e.g) Fish in the terminal.
    # This way you get the best of both POSIX compliance and Fish completions.
    # You will need to enable the desired shell for this to work.
    launchShell = ""; # can be: "zsh". "fish" or "nushell". "" is no shell.
  };

  # Fish - The Friendly Interactive Shell. Simple and easy to use.
  programs.fish = disabled // { shellAbbrs.sh- = "sh -c '"; };

  #====<< Terminal programs >>=================================================>
  programs = {
    # Git version control.
    git = enabled // {
      userName  = gitUsername;
      userEmail = gitEmail;
    };
    # Git terminal user interface
    lazygit = enabled;
    # Customisable shell prompt.
    starship = enableAllShells // { useSubDir = true; };
    # A "Post-modern terminal modal editor".
    helix = enabled // { defaultEditor = true; };
    # Terminal file manager.
    yazi = enableAllShells;
    # A powerfull fuzzy finder. Replaces your history search.
    fzf = enabled;
    # A better `grep` command.
    ripgrep = enabled;
  };

};}
