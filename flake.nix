{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-compat.url = "github:edolstra/flake-compat";
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
        { pkgs, lib, ... }:
        let
          vim9-brain = pkgs.vimUtils.buildVimPlugin {
            name = "vim9-brain";
            src = lib.cleanSource ./.;
          };
          vim-customized = pkgs.vim-full.customize {
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
          };
          test-runner = pkgs.stdenv.mkDerivation {
            name = "vim9-brain_test-runner";
            src = lib.cleanSource ./.;

            buildInputs = [
              pkgs.vimPlugins.vim-themis
              vim-customized
            ];

            buildPhase = ''
              mkdir -p $out/share
              export LANG=C

              themis -r | tee $out/share/themis-result.txt
            '';
          };
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.actionlint.enable = true;
            programs.mdformat.enable = true;
          };

          checks = {
            inherit vim9-brain test-runner;
          };

          packages = {
            inherit vim9-brain;
            default = vim9-brain;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              vim-customized
              pkgs.vimPlugins.vim-themis
              pkgs.nil
            ];
          };
        };
    };
}
