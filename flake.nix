{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        { pkgs, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.mdformat.enable = true;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              (pkgs.vim-full.customize {
                vimrcConfig = {
                  customRC = ''
                    set number
                    syntax on

                    set textwidth=0
                    set autoindent
                    set smartindent
                    set smarttab
                    filetype plugin indent on

                    set tabstop=4 shiftwidth=4 expandtab

                    if has("autocmd")
                      autocmd filetype vim setlocal tabstop=2 shiftwidth=2 expandtab
                      autocmd filetype nix setlocal tabstop=2 shiftwidth=2 expandtab
                      autocmd filetype markdown setlocal tabstop=2 shiftwidth=2 expandtab
                      autocmd filetype json setlocal tabstop=2 shiftwidth=2 expandtab
                    endif
                  '';
                  packages.testingPackage = {
                    start = [ pkgs.vimPlugins.vim-themis ];
                  };
                };
              })
              pkgs.vimPlugins.vim-themis
              pkgs.nil
            ];
          };
        };
    };
}
