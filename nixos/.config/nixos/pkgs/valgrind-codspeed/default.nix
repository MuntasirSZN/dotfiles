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
  cmake,
  python3,
}:

let
  # Capstone for Callgrind per-instruction cycle estimation (--cycle-estimation=yes).
  # Valgrind tools link -nodefaultlibs and have no glibc %fs TLS, so capstone must
  # be built without stackprotector (its %fs:0x28 canary faults at runtime) and
  # without fortify (pulls __*_chk symbols the tool doesn't shim). x86 + arm64
  # only — drops non-target instruction printers that reference libc symbols.
  capstone = stdenv.mkDerivation rec {
    pname = "capstone";
    version = "5.0.5";

    src = fetchFromGitHub {
      owner = "capstone-engine";
      repo = "capstone";
      rev = "refs/tags/${version}";
      hash = "sha256-VGqqrixg7LaqRWTAEBzpC+gUTchncz3Oa2pSq8GLskI=";
    };

    nativeBuildInputs = [ cmake gnumake gcc ];

    cmakeFlags = [
      "-DCAPSTONE_ARCHITECTURE_DEFAULT=OFF"
      "-DCAPSTONE_X86_SUPPORT=ON"
      "-DCAPSTONE_ARM64_SUPPORT=ON"
    ];

    hardeningDisable = [
      "stackprotector"
      "fortify"
      "fortify3"
    ];

    meta = with lib; {
      description = "Capstone disassembly framework (x86 + arm64, static, no hardening)";
      platforms = platforms.linux;
      license = licenses.bsd3;
    };
  };

in
stdenv.mkDerivation rec {
  pname = "valgrind-codspeed";
  version = "3.26.0-0codspeed6";

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "valgrind-codspeed";
    rev = "refs/tags/${version}";
    hash = "sha256-iSeNAbaX0U8d6rlSXbvZb/aAvEegaVo3dMgfcO27xbU=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    gnumake
    gcc
    pkg-config
    python3
  ];

  # Valgrind tool objects link -nodefaultlibs and run without glibc's %fs TLS,
  # so the toolchain must not inject stack-protector or fortify (__*_chk).
  hardeningDisable = [
    "stackprotector"
    "fortify"
    "fortify3"
  ];

  configureFlags = [
    "--with-capstone=${capstone}"
  ] ++ lib.optional stdenv.hostPlatform.isx86_64 "--enable-only64bit";

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
