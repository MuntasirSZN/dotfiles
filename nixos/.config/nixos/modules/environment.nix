# Environment variables and session variables.
{
  pkgs,
  ...
}:

{
  environment = {
    variables = {
      CC = "/home/muntasir/.cargo/bin/kache clang";
      CXX = "/home/muntasir/.cargo/bin/kache clang++";
      CFLAGS = "-fuse-ld=mold";
    };

    sessionVariables = {
      LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
      VALGRIND_REQUESTS_VALGRIND_INCLUDE = "${pkgs.callPackage ../pkgs/valgrind-codspeed { }}/include";
      PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";
      AR = "llvm-ar";
      NM = "llvm-nm";
      RANLIB = "llvm-ranlib";
      STRIP = "llvm-strip";
      OBJCOPY = "llvm-objcopy";
      OBJDUMP = "llvm-objdump";
      READELF = "llvm-readelf";
      ADDR2LINE = "llvm-addr2line";
      STRINGS = "llvm-strings";
      SIZE = "llvm-size";
    };
  };
}
