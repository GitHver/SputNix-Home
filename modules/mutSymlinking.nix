{ pkgs
, lib
, config
, self
, alib
, ...
}:

let
  inherit (builtins) attrNames concatMap;
  inherit (lib) mkOption;
  inherit (lib.strings) removePrefix;
  inherit (alib) attrsFromList;
  inherit (lib.types) attrs;
  inherit (lib.filesystem) listFilesRecursive pathIsDirectory;
  removePathPrefix = first: second: removePrefix (toString first) (toString second);
  mkMutSymlink = config.lib.file.mkOutOfStoreSymlink;
  path = config.home.sessionVariables.HOMEMANAGER_REPO;
  cfg = config.home.mutableFile;
in {

  options = {
    home.mutableFile = mkOption {
      type = attrs;
      default = {};
    };
  };

  config = {
    home.file =
      # What is needed:
      # Directory to set file into (`to`: ".config")
      # the file to create (".config/helix/config.toml")
      # The file to symlink (`from`: $HOME + REPO + assets/dot-config/helix/config.toml)
      attrNames cfg # [ ".config" ... ]
      |> concatMap (to:
        let
          src = cfg."${to}".source;
        in
          (if pathIsDirectory src then listFilesRecursive src else [ src ])
          |> map (file:
            path + removePathPrefix self file
            # resulkts in [ /home/USER/HOMEMANAGER_REPO/assets/dot-config/config.toml ... ]
            |> mkMutSymlink
            |> (source: { "${to + removePathPrefix src file}".source = source; })
          )
      )
      |> attrsFromList
    ;
  };

}
