{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  gnumake,
  gcc,
  pkg-config,
  python3,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "valgrind-codspeed";
  version = "3.26.0-0codspeed14";

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "valgrind-codspeed";
    rev = "refs/tags/${version}";
    hash = "sha256-JAf7kVkK0m1WukCxIokq4cJq3PcXGmkdeaIM0rNYdKQ=";

    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    gnumake
    gcc
    pkg-config
    python3
    perl
  ];

  hardeningDisable = [
    "stackprotector"
    "fortify"
    "fortify3"
  ];

  configureFlags = [
    "--enable-only64bit"
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  enableParallelBuilding = true;

  # Separate debug info for valgrind tools is needed for meaningful
  # stack traces in profiles.
  separateDebugInfo = true;

  meta = with lib; {
    description = "Valgrind fork with CodSpeed enhancements for performance profiling";
    homepage = "https://github.com/CodSpeedHQ/valgrind-codspeed";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
