{ ############################ Initial scope ###################################

  # This is not needed if you don't plan on making this flake public.
  description = ''
    My personal Home manager flake!
  '';

  inputs = {
    #====<< Core Nixpkgs >>====================================================>
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #====<< Home manager >>====================================================>
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #====<< Other >>===========================================================>
    sputnix-extras.url = "github:GitHver/nixisoextras";
    sputnix-extras.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: let
    #====<< Required variables >>======>
    lib = nixpkgs.lib;
    alib = inputs.sputnix-extras.lib; # // Other libraries
    #====<< Used functions >>==========>
    inherit (lib) genAttrs;
    inherit (lib.lists) flatten;
    inherit (lib.filesystem) listFilesRecursive;
    inherit (alib) attrsForEach getBaseFileNames;
    inherit (home-manager.lib) homeManagerConfiguration;
    #====<< Personal Attributes >>=====>
    pAtt = rec {
      parentRepo      = "/Nix";
      homeManagerRepo = "/home-manager";
      nixosRepo       = "/nixos-config";
      username    = "your_username";
      email       = "your@email.com";
      gitUsername = username;
      gitEmail    = email;
      gitMbranch  = "main";
    };
    #====<< Other >>===================>
    # This is only for the formatter, as it is not tied to an active system.
    genEachArch = (func: genAttrs supportedArchs func);
    supportedArchs = [
      "x86_64-linux"
      "x86_64-darwin"
      "i686-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  in {

    #====<< Nix Code Formatter >>==============================================>
    # This defines the formatter that is used when you run `nix fmt`. Since this
    # calls the formatters package, you'll need to define which architecture
    # package is used so different computers can fetch the right package.
    formatter = genEachArch (system:
      let pkgs = import nixpkgs { inherit system; };
      in pkgs.nixpkgs-fmt
      or pkgs.nixfmt-rfc-style
      or pkgs.alejandra
    );

    #====<< Home manager configurations >>=====================================>
    homeConfigurations = attrsForEach (getBaseFileNames ./hosts) (host: {
      "${pAtt.username}@${host}" = homeManagerConfiguration {
        pkgs = import nixpkgs { system = import ./hosts/${host}/arch.nix; };
        extraSpecialArgs = { inherit self inputs alib pAtt; };
        modules = flatten [
          ./hosts/${host}
          self.homeModules.default
        ];
      };
    });

    #====<< Home manager modules >>============================================>
    homeModules = rec {
      personal = { imports = listFilesRecursive ./modules; };
      default = [ personal ] ++ input-modules;
      input-modules = [ ];
    };

  };

}
