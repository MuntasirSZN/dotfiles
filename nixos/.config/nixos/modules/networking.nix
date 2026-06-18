# Hostname, network management, DNS.
{ ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    networkmanager.dns = "none";
    dhcpcd.extraConfig = "nohook resolv.conf";
  };
}
