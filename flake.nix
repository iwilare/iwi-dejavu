{
  description = "Custom font for iwilare";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    { name = "IwiDejaVu"; } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        iwidejavu = pkgs.stdenvNoCC.mkDerivation {
          name = "IwiDejaVu";
          src = pkgs.fetchzip {
            url =
              "https://github.com/ToxicFrog/Ligaturizer/releases/download/v5/LigaturizedFonts.zip";
            sha256 = "sha256-2ywFe7khH4WRmQoKwkDHacqKOPGve5fYFaNYGoPJsQ4=";
            stripRoot = false;
          };
          noConfig = true;
          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c $src/LigaDejaVuSansMono.ttf
            ${pkgs.fontforge}/bin/fontforge -c "\
              f=open('LigaDejaVuSansMNerdFont-Regular.ttf');\
              f.fontname=f.fullname=f.familyname='IwiDejaVu';\
              f.generate('IwiDejaVu.ttf')"
            cp IwiDejaVu.ttf $out/share/fonts/truetype/
          '';
          meta = {
            description =
              "Custom DejaVu Mono-inspired font with Ligaturizer and full Nerd Font patching";
          };
        };
        dejavusansmonocode-nerd-font = pkgs.stdenvNoCC.mkDerivation {
          name = "dejavusansmonocode-nerd-font";
          src = pkgs.fetchzip {
            url =
              "https://github.com/mdschweda/dejavusansmonocode/releases/download/v1.1/DejaVuSansMonoCode.zip";
            sha256 = "sha256-MJPTJoKDzCEgbrYZ/66fHkLSpO34RDF5Jix+1n2Xfck=";
            stripRoot = false;
          };
          noConfig = true;
          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            for f in *.ttf; do
              ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c $f -o $out/share/fonts/truetype/
            done
          '';
          meta = {
            description =
              "DejaVu Sans Mono Code with complete Nerd Font patching";
          };
        };
        dejavusanscode-nerd-font = pkgs.stdenvNoCC.mkDerivation {
          name = "dejavusanscode-nerd-font";
          src = pkgs.fetchzip {
            url =
              "https://github.com/SSNikolaevich/DejaVuSansCode/releases/download/v1.2.2/dejavu-code-ttf-1.2.2.zip";
            sha256 = "sha256-208QBXkeQIMwawCDhVG4DNqlGh5GYfhTNJybzMZhE/4=";
          };
          noConfig = true;
          installPhase = ''
            cd ttf
            mkdir -p $out/share/fonts/truetype
            for f in *; do
              ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c $f -o $out/share/fonts/truetype/
            done
          '';
          meta = {
            description = "DejaVu Sans Code with complete Nerd Font patching";
          };
        };
      in {
        packages = {
          inherit dejavusansmonocode-nerd-font;
          inherit dejavusanscode-nerd-font;
          inherit iwidejavu;
          default = iwidejavu;
        };
      });
}
