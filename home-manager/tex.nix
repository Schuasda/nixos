{ pkgs, ... }:
let
  latex-oth = pkgs.stdenvNoCC.mkDerivation {
    name = "latex-oth";
    src = ./texmf_OTHR;
    installPhase = ''
      # mkdir -p $out
      cp -r $src $out
      # if command -v texhash >/dev/null 2>&1; then texhash $out/share/texmf || true; fi
    '';
    passthru = {
      tlType = "run";
      # texlive will look for a 'tex' attribute on the derivation; many texlive helpers use passthru.tex
      tex = {
        path = "$out/share/texmf";
      };
    };

  };

  # tex = pkgs.texlive.combine {
  #   inherit (pkgs.texlive) scheme-full;
  #   inherit latex-oth;
  # };

in
{
  # expose the derivation so it can be imported by home.nix
  # inherit latex-oth;
  latex-oth = {
    pkgs = [ latex-oth ];
  };
}
