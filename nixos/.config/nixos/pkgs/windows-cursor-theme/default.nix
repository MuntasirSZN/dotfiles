{ stdenvNoCC, lib }:

stdenvNoCC.mkDerivation {
  pname = "windows-cursor-theme";
  version = "unstable";

  src = ./Windows;

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/Windows
    cp -a index.theme cursor.theme $out/share/icons/Windows/
    cp -a cursors $out/share/icons/Windows/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Windows-style Xcursor theme (Taken from Windows-Cursor-Concept-v2)";
    license = licenses.unfree;
    platforms = platforms.unix;
  };
}
