# Environment variables and session variables.
{
  lib,
  pkgs,
  ...
}:

{
  environment.variables = {
    CC = "clang";
    CXX = "clang++";
    # qt-build-utils only includes module directories under qtbase's prefix.
    # On NixOS each Qt module lives in a separate store path, so modules
    # like Multimedia and WebEngine are missed. Add their include dirs
    # explicitly so cc-rs passes them to the C++ compiler.
    # qt-build-utils's include_paths constructs ${QT_INSTALL_HEADERS}/Qt{module}
    # for each module. For modules in qtbase (Core, Gui, Widgets, etc.) these
    # exist under qtbase's own include dir. For modules in separate Nix store
    # paths (Multimedia, WebEngine) they don't, so the headers are never added.
    # The forwarding headers (<QMediaPlayer>, <QWebEngineHistory>) then pull
    # in sub-includes with module-qualified paths like <QtMultimedia/foo.h> or
    # <QtWebEngineCore/foo.h>. Provide both the module subdirectory (for the
    # forwarding header itself) and the base include dir (for the qualified
    # includes inside it).
    CXXFLAGS = lib.concatStringsSep " " [
      # Module subdirectories — for bare includes like <QMediaPlayer>
      "-I${pkgs.qt6.qtmultimedia}/include/QtMultimedia"
      "-I${pkgs.qt6.qtmultimedia}/include/QtMultimediaWidgets"
      "-I${pkgs.qt6.qtwebengine}/include/QtWebEngineCore"
      "-I${pkgs.qt6.qtwebengine}/include/QtWebEngineWidgets"
      # Base include dirs — for qualified includes like <QtMultimedia/foo.h>
      "-I${pkgs.qt6.qtmultimedia}/include"
      "-I${pkgs.qt6.qtwebengine}/include"
      # GL headers
      "-I${pkgs.libglvnd.dev}/include"
    ];
  };

  environment.sessionVariables = {
    PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";
    # qt-build-utils's cargo_link_libraries emits rustc-link-lib for all
    # Qt modules but only sets rustc-link-search for qtbase's lib dir.
    # Append extra lib dirs so the linker finds Multimedia/WebEngine libs.
    # rustc-link-search points to /run/qt6-lib (via QMAKE wrapper), which
    # only has .prl symlinks, not the actual .so files. Add all Qt lib dirs
    # explicitly so the linker finds the shared libraries.
    LIBRARY_PATH = "$NIX_LD_LIBRARY_PATH:${pkgs.qt6.qtbase}/lib:${pkgs.qt6.qtmultimedia}/lib:${pkgs.qt6.qtwebengine}/lib:${pkgs.qt6.qtdeclarative}/lib:${pkgs.qt6.qtwebchannel}/lib:${pkgs.qt6.qtpositioning}/lib";
    LD_LIBRARY_PATH = "$NIX_LD_LIBRARY_PATH";
    # qt-build-utils uses qmake -query QT_INSTALL_LIBS to locate .prl files.
    # Our tmpfiles rule puts symlinks at /run/qt6-lib; this wrapper returns
    # that path for the LIBS query and delegates everything else to real qmake.
    QMAKE = "${pkgs.writeShellScriptBin "qmake-wrapper" ''
      if [ "$1" = "-query" ] && [ "$2" = "QT_INSTALL_LIBS" ]; then
        echo "/run/qt6-lib"
      elif [ "$1" = "-query" ] && [ "$2" = "QT_INSTALL_HEADERS" ]; then
        echo "${pkgs.qt6.qtbase}/include"
      else
        exec "${pkgs.qt6.qtbase}/bin/qmake" "$@"
      fi
    ''}/bin/qmake-wrapper";
  };
}
