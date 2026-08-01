# Font packages and fontconfig defaults.
{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      (pkgs.stdenvNoCC.mkDerivation {
        pname = "bijoy-fonts";
        version = "latest";

        src = pkgs.fetchFromGitHub {
          owner = "nazdridoy";
          repo = "bijoyLinux";

          rev = "main";
          hash = "sha256-/8vu0gpcu1BEHif/UWwAc1YxcuuEtQ0NQUdP8GcWE+w=";
        };

        installPhase = ''
          mkdir -p $out/share/fonts/truetype

          find . \
            \( -iname "*.ttf" -o -iname "*.otf" -o -iname "*.ttc" \) \
            -exec cp {} $out/share/fonts/truetype/ \; || true
        '';
      })
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-lgc-plus
      noto-fonts-color-emoji
      liberation_ttf
      dejavu_fonts
      roboto
      symbola
      jetbrains-mono
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
      geist-font
      rubik
      nerd-fonts.ubuntu
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        monospace = [ "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>

          <!-- Bengali sans-serif -->
          <match target="pattern">
            <test name="lang" compare="contains">
              <string>bn</string>
            </test>
            <test qual="any" name="family">
              <string>sans-serif</string>
            </test>
            <edit name="family" mode="prepend">
              <string>SutonnyOMJ</string>
            </edit>
          </match>

          <!-- Bengali monospace -->
          <match target="pattern">
            <test name="lang" compare="contains">
              <string>bn</string>
            </test>
            <test qual="any" name="family">
              <string>monospace</string>
            </test>
            <edit name="family" mode="prepend">
              <string>Noto Sans Bengali</string>
            </edit>
          </match>

        </fontconfig>
      '';
    };
  };
}
