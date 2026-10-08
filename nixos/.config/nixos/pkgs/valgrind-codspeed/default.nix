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
  version = "3.26.0-0codspeed8";

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "valgrind-codspeed";
    rev = "refs/tags/${version}";
    hash = "sha256-prvMDkZMRyb0ISwwOM9VUHzVgfkOvBx83h7+QpDmQh8=";

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
